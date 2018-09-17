require_relative '../database'

describe Database do
  let(:queries)  do 
    {
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
  end
  let (:db_url) { 'postgres://localhost/framework_dev' }
  let (:db) { Database.connect(db_url, queries) }

  before(:each) do
    db.create
  end

  after(:each) do
    db.destroy
  end

  it 'is not vulnerable to SQL injection' do
    name = "'; drop table submissions; --"

    expect { db.create_submission(name: name, email: "") }
    .to change { db.all_submissions.length }
    .by(1)
  end



  it 'retrieves the associated name of a given submission' do
    name = 'Brian'
    email = 'brian@brian.com'
    db.create_submission(name: name, email: email)
    user = db.find_submission_by_user(name: name)[0]
    
    expect(user.name).to eq(name)
  end

  it 'retrieves the associated name of a given submission in different order' do

    name = 'Brian'
    email = 'brian@brian.com'
    db.create_submission(email: email, name: name)
    user = db.find_submission_by_user(name: name)[0]
    
    expect(user.name).to eq(name)
  end
end