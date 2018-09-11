require_relative '../database'

describe Database do
  let(:queries)  do 
    {
      all_submissions: %{
        select * from submissions;
      },
      create_submission: %{
        insert into submissions(name)
        values ($1)
      },
      find_submission_by_user: %{
        SELECT * FROM submissions WHERE name = $1
      }
    }
  end
  let (:db_url) { 'postgres://localhost/framework_dev' }
  let (:db) { Database.connect(db_url, queries) }

  it 'is not vulnerable to SQL injection' do
    name = "'; drop table submissions; --"

    expect { db.create_submission(name) }
    .to change { db.all_submissions.length }
    .by(1)
  end

  it 'retrieves the associated name of a given submission' do
    name = 'Brian'
    db.create_submission(name)
    user = db.find_submission_by_user(name)[0]
    
    expect(user.name).to eq(name)
  end
end