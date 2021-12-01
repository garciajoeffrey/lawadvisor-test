defmodule Lawadvisor.Repo.Migrations.CreateAddTaskNoFunction do
  use Ecto.Migration

  def change do
    execute """
      DROP FUNCTION IF EXISTS public.add_task(character, integer, character);
    """

    execute """
      CREATE OR REPLACE FUNCTION public.add_task(
        userID character,
        taskNo integer,
        taskDetails character
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

        --- Update task numbers
        IF taskNo != 0 AND taskNo <= latestTaskNo THEN
          UPDATE tasks SET task_no = task_no + 1 WHERE user_id = userID::uuid and task_no >= taskNo;
        END IF;

        --- Add latest task number to empty task number
        IF taskNo = 0 THEN
          SELECT coalesce(latestTaskNo, 0) + 1 INTO taskNo;
        END IF;

        --- Insert new task
        INSERT INTO tasks (id, user_id, task_no, details, inserted_at, updated_at) VALUES (uuid_generate_v4(), userID::uuid, taskNo, taskDetails, now(), now());

        RETURN FOUND;

      END;

      $BODY$;
    """
  end
end
