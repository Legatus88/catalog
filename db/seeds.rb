User.create(login: 'first_user', password: '123456', password_confirmation: '123456')
User.create(login: 'second_user', password: '123456', password_confirmation: '123456')

i = 1
10.times do
  User.first.articles.create(text: "first user text #{i}", title: "first user title #{i}", preview: "first user preview #{i}")
  User.last.articles.create(text: "second user text #{i}", title: "second user title #{i}", preview: "second user preview #{i}")
  i += 1
end

ReadArticle.create(user: User.first, article: Article.first)
Favorite.create(user: User.find(2), article: Article.find(2))
