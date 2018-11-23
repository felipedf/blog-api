require 'rails_helper'

describe ArticlesController do
  describe '#index' do
    subject { get :index }
    it 'should return success response' do
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'should return proper json' do
      create_list :article, 2
      subject
      expect(json_data.length).to eq(2)
      expect(json_data[0]['attributes']).not_to be_nil
    end

    it 'should return articles ordered by the most recent' do
      old_article = create :article
      new_article = create :article
      subject
      expect(json_data.first['id']).to eq(new_article.id.to_s)
      expect(json_data.second['id']).to eq(old_article.id.to_s)
    end

    it 'should paginate results' do
      create_list :article, 3
      get :index, params: { page: 2, per_page: 1 }
      expect(json_data.length).to eq(1)
      expected_article = Article.recent.second.id.to_s
      expect(json_data.first['id']).to eq(expected_article)
    end
  end

  describe '#show' do
    # it 'should return success response' do
    #   create :article
    #   get :show
    #   expect(response).to have_http_status(:ok)
    # end
  end
end