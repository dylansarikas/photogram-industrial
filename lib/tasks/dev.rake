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

  usernames = Array.new { Faker::Name.first_name }

  usernames << "alice"
  usernames << "bob"

  10.times do
    usernames << Faker::Name.first_name
  end

  usernames.each do |username|
    User.create(
      email: "#{username}@example.com",
      password: "password",
      username: username.downcase,
      private: [true, false].sample,
    )
    #p user.errors.full_messages
  end
  
  p "There are now #{User.count} users."

  users = User.all

  users.each do |first|
    users.each do |second|
      next if first == second
      if rand < 0.667
        first.sent_follow_requests.create(
          recipient: second,
          status: FollowRequest.statuses.values.sample
        )
      end

      if rand < 0.667
        first.sent_follow_requests.create(
          recipient: second,
          status: FollowRequest.statuses.values.sample
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

      user.followers.each do |follower|
        if rand < 0.4 && !photo.fans.include?(follower)
          photo.fans << follower
        end

        if rand < 0.2
          photo.comments.create(
            author: follower,
            body: Faker::Quote.most_interesting_man_in_the_world
          )
        end
      end
    end
  end

  p "There are now #{FollowRequest.count} follow requests"
  p "There are now #{Photo.count} photos"
  p "There are now #{Comment.count} comments"
  p "There are now #{Like.count} likes"
end
