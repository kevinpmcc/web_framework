QUERIES = {
  all_submissions: %{
    SELECT * FROM submissions;
  },
  find_submission_by_user: %{
    SELECT * FROM submissions WHERE name = '%s'
  }
}