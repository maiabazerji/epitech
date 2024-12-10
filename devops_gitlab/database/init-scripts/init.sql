DO $$ 
BEGIN
   IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'trinity_db') THEN
      CREATE DATABASE trinity_db;
   END IF;
END $$;
