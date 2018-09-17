QUERIES = {
  destroy: %{
    drop table if exists submissions;
  },
  create: %{
    create table if not exists submissions(name text, email text);
  },
  all_submissions: %{
    select * from submissions;
  },
  create_submission: %{
    insert into submissions(name, email)
      values ({name}, {email})
  },
  find_submission_by_user: %{
    SELECT * FROM submissions WHERE name = {name}
  }
}