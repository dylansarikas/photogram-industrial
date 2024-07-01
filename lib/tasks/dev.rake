desc "Fill the database tables with some sample data"

task :sample_data => :environment do
  p "Creating sample data"

  if Rails.env.development?
    FollowRequest.destroy_all
    Comment.destroy_all
    Like.destroy_all
    Photo.destroy_all
    User.destroy_all
  end

  12.times do
    name =  Faker::Name.first_name
    user = User.create(
      username: name,
      email: name.downcase + "@email.com",
      password: "password",
      private: [true, false].sample
    )

    #p user.errors.full_messages
  end
  
  p "There are now #{User.count} users."

  users = User.all

  users.each do |first_user|
    users.each do |second_user|
      next if first_user == second_user
      if rand < 0.75
        first_user.sent_follow_requests.create(
          recipient: second_user,
          status: FollowRequest.statuses.keys.sample
        )
      end

      if rand < 0.75
        first_user.sent_follow_requests.create(
          recipient: second_user,
          status: FollowRequest.statuses.keys.sample
        )
      end
    end
  end

  users.each do |user|
    rand(10).times do
      photo = user.own_photos.create(
        image: "https://robohash.org/#{rand(9999)}",
        caption: Faker::Quote.famous_last_words
      )
    end
  end

  p "There are now #{FollowRequest.count} follow requests"
  p "There are now #{Photo.count} photos"
end
