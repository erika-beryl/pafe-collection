class ParfaitsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  def index
    @parfaits = Parfait
              .select("parfaits.*, COUNT(reviews.id) AS reviews_count")
              .left_joins(:reviews)
              .group("parfaits.id")
              .order(created_at: :desc)
  end

  def show
    load_parfait
    @reviews = @parfait.reviews.order(created_at: :desc)
  end

  def new
    @parfait = Parfait.new
  end
  
  def create
    @parfait = Parfait.new(parfait_params)

    if params[:parfait][:parfait_image].present?
      resized_images = resize_image_set_dpi(params[:parfait][:parfait_image])
      original_filename_base = File.basename(params[:parfait][:parfait_image].original_filename, ".*")

      @parfait.parfait_image.attach(
        io: resized_images,
        filename: "#{original_filename_base}.jpg",
        # ここでcontent_typeを指定しないと名前は.jpgの拡張子が付いているけどデータはpngみたいなことが起こる可能性がある
        content_type: 'image/jpg'
      )
    end

    if @parfait.save
      redirect_to @parfait, success: 'パフェが登録されました'
    else
      flash.now[:danger] = t('defaults.flash_message.not_created', item: Shop.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    load_parfait

  end

  def update
    load_parfait

    if params[:parfait][:remove_parfait_image] == '1'
      @parfait.parfait_image.purge if @parfait.parfait_image.attached?
    end

    if params[:parfait][:parfait_image].present?
      resized_images = resize_image_set_dpi(params[:parfait][:parfait_image])
      original_filename_base = File.basename(params[:parfait][:parfait_image].original_filename, ".*")

      @parfait.parfait_image.attach(
        io: resized_images,
        filename: "#{original_filename_base}.jpg",
        # ここでcontent_typeを指定しないと名前は.jpgの拡張子が付いているけどデータはpngみたいなことが起こる可能性がある
        content_type: 'image/jpg'
      )
    end

    if @parfait.update(parfait_params.except(:remove_parfait_image))
      redirect_to @parfait, success: 'パフェが更新されました', status: :see_other
    else
      flash.now[:danger] = "パフェを更新できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    load_parfait
    @parfait.destroy!
    redirect_to parfaits_path, success: '削除に成功しました'
  end

  private

  def parfait_params
    params.require(:parfait).permit(:name, :body, :price, :is_limited).merge(shop_id: params[:shop_id] || @parfait&.shop_id)
  end

  def load_parfait
    @parfait = Parfait.includes(:shop).find(params[:id])
  end

  def resize_image_set_dpi(uploaded_file)
    # uploaded_file.tempfileから画像を読み込み、MiniMagickオブジェクトとして扱う
    image = MiniMagick::Image.read(uploaded_file.tempfile)
    # 画像の縦幅を1350ピクセルにリサイズ
    image.resize 'x1350'
    # 画像の解像度を96 DPIに設定
    image.density '96'

    # 一時ファイルを作成
    tempfile_jpg = Tempfile.new('resized')
    # 変更された画像を一時ファイルに書き込み（ここで画像が指定されたリサイズと解像度で保存される）
    image.write (tempfile_jpg.path)
    # ファイルを読み込む準備
    tempfile_jpg.rewind
    # 一時ファイルを呼び出す
    tempfile_jpg
  end

end
