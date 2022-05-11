# Project

Posterr - posterr

## Install

### Clone the repository

### Check your Ruby version

```shell
ruby -v
```

The ouput should start with something like `ruby 3.0.0`

If not, install the right ruby version using [rbenv](https://github.com/rbenv/rbenv) (it could take a while):

```shell
rbenv install 3.0.0
```

### Database

PostgreSQL. Versions 9.3 and up are supported.

Setup:
```ruby
rails db:create
rails db:migrate
```

### Install dependencies

Using [Bundler](https://github.com/bundler/bundler)

```shell
bundle
```
## Serve

```shell
rails s
```

## Testing

```shell
bundle exec rspec --format documentation
```

## API Documentation

```shell
rails s
```
And now you can check Posterr API docs with the URL http://localhost:3000/api-docs

## Planning

### Doubts

Hello,
I have some doubts in respect of the "Posts and Replies" part, the secondary feed which will be added in the users profile. How do we plan to order the list of posts and replies? Are we going to group replies by posts?

- Post
  |- Reply
  |- Reply
- Post
  |- Reply
...

I guess we will also use same order logic from Feed and Profile, showing the latest first and loading posts by chunks on demand. Is that correct? If yes, we also need to define how many posts and replies we will show in each chunk. Also, which posts do we want to list in this page? I'm seeing two possibilities, posts and replies from posts created by the user and posts where user left a reply.

In respect of the Reply model, how many characters will be permitted to exist in a reply text? I assume we are going to require a reply to have content. It is also important to define if replies are going to count on our daily entries limit, in my solution I assume it won't.

### Solution

My solution for this feature would include add a Reply entity in the system. For that, we would need to add a new table in the database, called replies. Which would reference a post and a user, the one whose created the reply to the post. Users and posts would have many replies and a reply would belong to a user and a post.

- Replies -
- post_id - foreign_key: true
- user_id - foreign_key: true
- content - null: false

To interact with FE, we would need to add an endpoint to create replies. Through this endpoint server would expect to receive three required parameters:

> ID from user whose left the reply;
> ID from replied post;
> content from the reply.

Also, it would be necessary to add two endpoints to support the "Posts and Replies" section. I assume we will list a chunk of posts that can be lazy loaded by the user. The first endpoint would cover listing a defined quantity of posts, with a defined quantity of replies to each post. The second one would return chunks of replies for each post independently, as the user requests to see more replies.

## Critique

Hello, yes I would improve some parts if I had more time to work on it. 

First thing would be to define an authentication engine to handle user sessions. For now, I decided to send the current user ID through query parameters. This would to make it easier to replace by the chosen authentication engine. With more time, I'd also add a token to handle that instead of raw user IDs. But I thought that this can be qualified as "building authentication", which we are explicitly told not to do in the test requirements. IDs are sequentially defined in by the DB and could be scanned. Adding a slug mask or Rails UUID's to some tables could be helpful.

Count actions won't perform well as tables grow, for now we have a naive approach performing this count every time someone reaches the endpoints. We can add rails counter cache and save these counting results on the DB. That would trigger a callback to count records after any change on follow relationships. As this scales, we could also could have some problems with table locks. The next step would be store the changes on the tables in a faster storage like Redis first and sync later with the DB. 

Also, we could use a queue manager as Sidekiq to send these processes to a background worker. Which would also be my choice in case of operations we had a long I/O wait on the system, Sidekiq concurrency fits well to increase throughput in these cases. Other possibility would be to add a DB read replica, which would help to free up connections for writing operations like creating entries and follows. 

I'd like to have more time to add some endpoints and server interactions with the UI. For example, create a separated endpoint for user profile entries list, to serve entries without calculating the user info unnecessarily. With more time I'd also add examples of entries info response to the API documentation.

 We would also need to define a git workflow to have better control of project versions. Create pull request policies to develop branch merges, requiring code review approval and test suite check. For now, as we don't have other developers, I've decided to commit each feature directly to the develop branch and merge to the main branch in 1st release.
