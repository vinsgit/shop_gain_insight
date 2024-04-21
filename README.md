# Shop Gain Insight

## Description

Shop Gain Insight is a financial system tailored specifically for our Amazon business investors. It facilitates the precise calculation of investments and returns, providing valuable insights for informed decision-making.

## Features

As of April 2024, the key features of this system include:

- Creation of users
- Creation of shops
- Importing data from various sheets
- Listing the imported data

## Installation

Follow these steps to set up the Shop Gain Insight system on your local machine:

```bash
# Clone the repository
git clone <repository-url>

# Navigate to the project folder
cd project-folder

# Install dependencies
bundle install

# Create the database
rake db:create

# Run migrations
rake db:migrate
```

Once you have registered your account and created your shop, you need to initialize the SKU data for the shop. Run the following command:

```bash
rake import:skus
```

Please note that this is a temporary solution for now.

## Business Logic notes
表格修改
- 采购表
  - 折后价-合计 去掉，将运费加入到每个商品的单价里，保证单价*数量就为总价（包括每个商品的运费）
  - 付款人，不要换行。中文逗号“，”区分不同投资人，中文“：”区分比例，例如“某某：20%，某某：80%”
- FMB发货表
  - 金额不要合并表格，且不要用=22+33这种公式，直接写结果。
- 广告数据
  - 用 -- 区分sku和其他文字