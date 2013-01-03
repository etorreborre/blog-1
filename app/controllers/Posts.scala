package controllers

import play.api.mvc._
import models._
import play.api.cache.Cached

object Posts extends Controller with AkkaExecutionContext {
  import play.api.Play.current
  import akkaSystem.dispatcher

  def index = Cached("posts", 60) {
    Action {
      Async {
        for {
          categories <- Category.titles
          recent <- Post.recent
          archive <- Post.archive(recent.last.key)
        }
        yield Ok(views.html.Posts.index(recent.map(_.value), archive.map(_.value), categories))
      }
    }
  }

  def show(slug: String) = Action {
    Async {
      for {
        post <- Post.getBySlug(slug)
        categories <- Category.titles
      } yield post.map { post =>
        Ok(views.html.Posts.show(post, categories))
      }.getOrElse(NotFound)
    }
  }

  def create = TODO

  def delete(id: String) = TODO
}