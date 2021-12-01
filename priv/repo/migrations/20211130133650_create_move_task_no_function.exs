defmodule Lawadvisor.Repo.Migrations.CreateMoveTaskNoFunction do
  use Ecto.Migration

  def change do
    execute """
      DROP FUNCTION IF EXISTS public.move_task(character, integer, character);
    """

    execute """
      CREATE OR REPLACE FUNCTION public.move_task(
        userID character,
        taskNo integer,
        newTaskNo integer
      ) RETURNS character varying LANGUAGE 'plpgsql'

      COST 100 VOLATILE AS $BODY$

      DECLARE
        latestTaskNo integer;

      BEGIN

        --- Get latest task number
        SELECT COALESCE(task_no, 1) INTO latestTaskNo FROM tasks WHERE user_id=userID::uuid ORDER BY task_no DESC;

        --- Validate task no
        IF taskNo > latestTaskNo THEN
          RETURN 'Task number does not exist';
        END IF;

        --- Validate new task no
        IF newTaskNo > latestTaskNo THEN
          RETURN 'New task number is invalid';
        END IF;

        -- Move task numbers
        UPDATE tasks SET task_no = 0 WHERE user_id = userID::uuid and task_no = taskNo;

        IF newTaskNo > taskNo THEN
          UPDATE tasks SET task_no = task_no - 1 WHERE user_id = userID::uuid and task_no <= newTaskNo and task_no > taskNo;
        ELSE
          UPDATE tasks SET task_no = task_no + 1 WHERE user_id = userID::uuid and task_no >= newTaskNo and task_no < taskNo;
        END IF;

        UPDATE tasks SET task_no = newTaskNo WHERE user_id = userID::uuid and task_no = 0;

        RETURN FOUND;

      END;

      $BODY$;
    """
  end
end
