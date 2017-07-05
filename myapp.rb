require 'sinatra'
require 'sinatra/reloader'
require 'active_record'

# 使用するDBを宣言
ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3",
  "database" => "./bbs.db"
)

class Comment < ActiveRecord::Base
end

# 入力にスクリプトが埋め込まれても実行されないようにエスケープする。
# erbファイルの入力のところでhを挿入することでエスケープできる。
helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

# 一覧表示。@commentsにコメント一覧が入っている。erbファイルではこれを呼び出す。
get '/' do
  @comments = Comment.order("id desc").all
  erb :index2
end

# bodyをキー、erbファイルで入力されたparams[:body]をバリューにしてDBに格納している
post '/new' do
  Comment.create({:body => params[:body]})
  redirect '/'
end

# 削除。idで削除。
post '/delete' do
  Comment.find(params[:id]).destroy
end
