class ArticleController
  # Creates a new article
  def create_article(article)
    # Check if an article with the same title already exists
    article_exists = !(Article.where(title: article['title']).empty?)

    return { ok: false, msg: 'Article with given title already exists' } if article_exists

    # Create a new article with the provided data
    new_article = Article.new(title: article['title'], content: article['content'], created_at: Time.now)
    new_article.save

    { ok: true, obj: new_article }
  rescue StandardError => e
    { ok: false, msg: e.message }
  end

  # Updates an existing article
  def update_article(id, new_data)
    # Find the article by its ID
    article = Article.find_by(id: id)

    return { ok: false, msg: 'Article could not be found' } if article.nil?

    # Update the article with the new data
    article.update(title: new_data['title'], content: new_data['content'])

    { ok: true, obj: article }
  rescue StandardError => e
    { ok: false, msg: e.message }
  end

  # Retrieves a single article by ID
  def get_article(id)
    # Find the article by its ID
    article = Article.find_by(id: id)

    if article
      { ok: true, data: article }
    else
      { ok: false, msg: 'Article not found' }
    end
  rescue StandardError => e
    { ok: false, msg: e.message }
  end

  # Deletes an article by ID
  def delete_article(id)
    # Find the article by its ID
    article = Article.find_by(id: id)

    if article
      article.destroy
      { ok: true, delete_count: 1 }
    else
      { ok: false, msg: 'Article does not exist' }
    end
  rescue StandardError => e
    { ok: false, msg: e.message }
  end

  # Retrieves all articles
  def get_batch
    # Fetch all articles from the database
    articles = Article.all

    { ok: true, data: articles }
  rescue StandardError => e
    { ok: false, msg: e.message }
  end
end
