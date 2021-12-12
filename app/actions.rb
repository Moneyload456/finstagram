#helper methods
helpers do
  #used so we don't need to constantly pull the current user info
  def current_user
    User.find_by(id: session[:user_id])
  end
end

# get method for the main page
get '/' do
  @finstagram_posts = FinstagramPost.order(created_at: :desc)
  erb(:index)
end

# if a user navigates to the path /signup, we will create an empty user object and then render the signup.erb
get '/signup' do
  @user = User.new
  erb(:signup)
end

# if a user navigates to the path /login, we will create an empty user object and then render the signup.erb
get '/login' do
  erb(:login)
end

# once the user has logged in the following will occur
post '/login' do
  username    =params[:username]
  password    =params[:password]
  #we are going to find the user's username
  @user = User.find_by(username: username)
  # if the user exist match the password
  if @user && @user.password == password
      session[:user_id] = @user.id
      redirect to('/')
  else 
    @error_message ="Login failed"
    erb(:login)
  end
end

# if the user wants to logout we are setting the user ID to be null
get '/logout' do 
  session[:user_id] = nil
  redirect to('/')
end

#once the signup page has been submitted the following will be used to store user input
post '/signup' do
  email       = params[:email]  
  avatar_url  = params[:avatar_url]
  username    = params[:username]
  password    = params[:password]
  
  # save and store the user information in the data base
  @user = User.new({email:email, avatar_url: avatar_url, username: username, password: password})

  if @user.save
    redirect to('/login')
    #want to print the user information but we need to remove the HTML tag as user isnt a proper HTML tag
  else 
    erb(:signup)
  end
end

# creating new finstagram post
get '/finstagram_posts/new' do
  @finstagram_post = FinstagramPost.new
  erb(:'finstagram_posts/new')
end

# posting new finstagram post
post '/finstagram_post' do 
  photo_url = params[:photo_url]
  @finstagram_post = FinstagramPost.new({ photo_url: photo_url, user_id: current_user.id })

  if @finstagram_post.save
    redirect(to('/'))
  else
    erb(:'finstagram_posts/new')
  end
end

#
get '/finstagram_posts/:id' do
  @finstagram_post = FinstagramPost.find(params[:id])
  erb(:"finstagram_posts/show")
end


post '/comments' do
  # saving variables
  text = params[:text]
  finstagram_post_id = params[:finstagram_post_id]
  #linking comment to values assigned the the current user
  comment = Comment.new({text: text, finstagram_post_id: finstagram_post_id, user_id:current_user.id})
  #save the comment
  comment.save
  #redirect back to main page
  redirect(back)
end

# creating a post method for likes
post '/likes' do
  finstagram_post_id = params[:finstagram_post_id]
  like = Like.new({ finstagram_post_id: finstagram_post_id, user_id: current_user.id })
  like.save
  redirect(back)
end

# deleting likes
delete '/likes/:id' do
  like= Like.find(params[:id])
  like.destroy
  redirect(back)
end

