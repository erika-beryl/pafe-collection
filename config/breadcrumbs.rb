crumb :root do
  link "Home", root_path
end

crumb :user_new do
  link "ユーザー登録", new_user_registration_path
  parent :root
end

crumb :shop_index do
  link "店舗一覧", shops_path
  parent :root
end

crumb :parfait_index do
  link "パフェ一覧", parfaits_path
  parent :root
end

crumb :review_index do
  link "レビュー一覧", reviews_path
  parent :root
end

crumb :user_profile do |user|
  link "プロフィール", users_profile_path(user)
  parent :root
end

crumb :shop_show do |shop|
  link "#{shop.name}の詳細", shop_path(shop)
  parent :shop_index
end

crumb :parfait_show do |parfait|
  link "#{parfait.name}の詳細", parfait_path(parfait)
  parent :parfait_index
end

crumb :review_show do |review|
  link "#{review.title}の詳細", review_path(review)
  parent :review_index
end

crumb :bookmark_index do
  link "あなたのいいね一覧"
  parent :root
end
# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).