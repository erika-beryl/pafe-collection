module ApplicationHelper
  def default_meta_tags
    {
      site: 'パフェコレ',
      title: 'パフェのレビューサイト',
      reverse: true,
      charset: 'utf-8',
      description: 'パフェコレは、パフェのレビューサイトです。',
      keywords: 'パフェ,口コミ',
      canonical: Rails.env.production? ? 'https://www.parfait-collection.com' : 'http://localhost:3000',
      separator: '|',
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: Rails.env.production? ? 'https://www.parfait-collection.com' : 'http://localhost:3000',
        image: image_url('ogp.png'),
        locale: 'ja-JP'
      },
      twitter: {
        card: 'summary_large_image',
        image: image_url('ogp.png'),
        title: 'パフェコレ | パフェのレビューサイト',
        description: 'パフェ好きのためのレビュー共有サービス！'
      }
    }
  end
end
