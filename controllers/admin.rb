class Blog
  class Admin < Harbor::Controller
  
    get do
      if authenticated?
        @posts = Post.all
        render "admin/index"
      else
        render "admin/login"
      end
    end
    
    get "/login" do
      render "admin/login"
    end

    post "/login" do |email, password|
      if request.session["auth"] = ::Admin.authenticate(email, password, nil)
        response.redirect("/admin")
      else
        @error = true
        render "admin/login"
      end
    end
    
    class Posts < Harbor::Controller
      
      get "new" do
        @post = ::Post.new
        render "admin/posts/edit"
      end
      
      get ":slug/edit" do |slug|
        @post = ::Post.get_by_slug slug
        render "admin/posts/edit"
      end
      
      post do |title, published_at, body, categories, id = nil|
        @post = Post.update id, title, published_at, body, categories
        if @post.errors.empty?
          response.redirect "/admin"
        else
          render "admin/posts/edit"
        end
      end
      
    end
    
    private
    def authenticated?
      if token = request.session["auth"]
        ::Admin.authenticate(nil, nil, token)
      else
        nil
      end
    end    
  end
end