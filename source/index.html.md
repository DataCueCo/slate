---
title: DataCue API

language_tabs: # must be one of https://git.io/vQNgJ
  - javascript--browser: Browser
  - javascript--node: Node.js
  - python: Python
  - php: PHP
includes:
  - errors

search: true
---

# Introduction

Welcome to the DataCue API guide! This API documentation is to help you setup your e-commerce store to apply real time personalization to your website.

## Sample code

We have code for your browser, Node, PHP and Python. You can view them in the dark area to the right. Click on the yellow tabs to switch the programming language. On a mobile device, switch the language using the hamburger menu on the top left.

## Getting started

There are three major steps to complete the integration.

### 1. Import your historical data
This is a one-time run. Refer to the [batch](#batch) endpoints to send us all your existing orders, products and users (sometimes called customers).

### 2. Integrate future store data changes
Use the appropriate endpoints to ensure all updates to your store data are synchronized with DataCue.

This includes:

- [Orders](#orders)
- [Products](#products)
- [Users](#users)

### 3. Integrate recommendations to your site with our Javascript library
Refer to the [browser events](#browser-events) section to understand all the events that you can send us via our Javascript library. All events have sample code attached, just copy/paste them and change the values as appropriate.

## Quick facts

### API URL

The API is located at `https://api.datacue.co`.

### Authentication

> Replace `API-key` with your API key and `API-secret` with your API secret. Browser events only need your api key, while the other endpoints require both.

```php
<?php

$apikey = "Your-API-Key-goes-here";
$apisecret = "Your-API-secret-goes-here";

$datacue = new \DataCue\Client($apikey, $apisecret);

$data = [
  "name"  => "Spongebob",
  "email" => "pineapple@underthe.sea"
];

$res = $datacue->users->create($data);

?>

```

```python
import hashlib
import hmac
import json
import requests

url = "https://api.datacue.co/v1/users"
apikey = "your-api-key-goes-here"
apisecret = "your-api-secret-goes-here"

data = {
  "name" : 'Spongebob',
  "email" : 'pineapple@underthe.sea'
}

checksum = hmac.new(bytes(apisecret,'utf-8'), bytes(json.dumps(data)), 'utf-8'), hashlib.sha256)

response = requests.post(url, json=data, auth=(apikey, checksum.hexdigest())
```

```javascript--node
const axios = require('axios');
const cryto = require('crypto');

const url = 'https://api.datacue.co/v1/users'
const apikey = 'your-api-key-goes-here';
const apisecret = 'your-api-secret-goes-here';

const newUser = {
  name : 'Spongebob',
  email : 'pineapple@underthe.sea'
}

var hash = crypto.createHmac('sha256', apisecret).update(JSON.Stringify(newUser));

//add to default authentication header
axios.defaults.auth = { username: 'API-key', password: hash.digest('hex') };

axios.post(url, data);
```

```javascript--browser
window.datacue.init('API-key');
```

> Sample Headers

```
"Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
"Content-Type": "application/json"
```

You can find your API key and API secret in your [DataCue Dashboard](https://app.datacue.co "Dashboard").

We use HTTP Basic Authentication, the username is your `apikey` and the password is a signed hash of the JSON payload you are sending. This way you don't need to send your actual api secret with the message. You get to keep it... a secret (sorry!).

The browser events are public so you only fill in the username field with your api key and leave the password blank. Our Javascript library manages authentication for you. Just pass the `apikey` to the `init()` method and you're done. See code sample on the right.

For all other endpoints, we have reference implementations on how to sign your message with your `apisecret` in Node, PHP and Python.

### Content-Type

Whenever you are sending us JSON (all endpoints except `DELETE`). Remember to set a content-type header to "application/json", some http libraries will do this for you automatically.
`Content-Type: application/json`

# Browser Events

> Remember to include the config snippet *before* the external scripts

```html
<script>
window.datacueConfig = {
  api_key: 'your-api-key',
  user_id: 'id of user (user_id field you send us for users)',
  page_type: 'product',
  product_id: 1234,
  variant_id: 2345
};
</script>
<script src="https://cdn.datacue.co/js/datacue.js"></script>
<script src="https://cdn.datacue.co/js/datacue-storefront.js"></script>
```

The easiest way to start tracking browser events is to include our scripts. You'll need only three things:

- The config object
- DataCue Events SDK
- DataCue storefront script

Place the snippets near the end of the `<head>` element of your main template. This will enable all the basic events:

- pageviews
- search
- banner/carousel clicks

## The config object

To properly set up tracking, you need to provide some information about the page that the user is currently visiting. You can do it by setting the following properties of the `window.datacueConfig` object:

| Property        | Required                      | Description |
| --------------- | ----------------------------- | ----------- |
| `api_key`       | Yes                           | Your API key
| `user_id`       | Yes (if logged in)            | If the visitor is not logged in, set the field to `null`
| `page_type`     | Yes                           | Current page. One of `'home'`, `'product'`, `'category'`, `'cart'`, `'search'` or `'404'`
| `product_id`    | If `page_type` = `'product'`  | On product pages, id of currently viewed product
| `variant_id`    | If `page_type` = `'product'`  | On product pages, id of currently viewed product variant, set to null if not applicable
| `category_name` | If `page_type` = `'category'` | On category pages, name of currently viewed category
| `term`          | If `page_type` = `'search'`   | On search results page, current search term

On product pages, you can also add an optional property `product_update` to the config object, to ensure that the most important information about your products is always synchronized. The following fields are supported at this time:

| Property        | Description |
| --------------- | ----------- |
| `name`          | Name of the product
| `price`         | Current price, after all discouts applied
| `full_price`    | Base price without any discounts
| `photo_url`     | URL of the main product photo
| `available`     | `true` or `false`
| `stock`         | Number of items remaining in stock
| `main_category` | Name of the main product category
| `categories`    | Array of product's category names
| `brand`         | Name of the brand

## Inserting banners

> Home page banners

```html
<div
  data-dc-banners
  data-dc-static-img="path/to/your/banner.jpg"
  data-dc-static-link="link/to/chosen/category"
></div>
```

Once you're done configuring tracking, you can enable our widgets. You can read all about banners [here](https://help.datacue.co/dashboard/banners.html).

Here's a brief summary:

1. There are two types of banners, wide: 1200x720px and narrow: 480x720px
2. You upload all the banners you want us to personalize directly to DataCue. 
2. The Static banner is a wide banner (1200x720px) that shows up for everyone. Tell us where it is with the `data-dc-static-img` attribute and what the link should be with the `data-dc-static-link` attribute and we'll do the rest.

## Inserting product carousels
> Product carousels

```html
<div data-dc-product-carousels></div>
```

We have three types of product carousels:

1. Recommendations: On every page except the product page, we show product recommendations tailored to the user. On the product page, this carousel is related to the current product being viewed based on other people's purchases.

2. Recently viewed: A list of all the products that were recently viewed by the user

3. Similar products: Only on the product page, all products that are similar to the existing product looking at name, brand, categories and description.

Just insert the following code and we'll do the rest. You can control which carousels you want to see and how many products in each carousel from your dashboard.

## Sending other events

> This is an example of a typical browser event. Notice that `context` and `timestamp` aren't necessary when you're sending events directly from the user's browser.

```json
{
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "07d35b1a-5776-4ddf-8f1c-dd0d2db9c502",
    "profile": {
      "sex": "female",
      "location": "Santiago",
      "segment": "platinum"
    }
  },
  "event": {
    "type": "pageview",
    "subtype": "home"
  }
}
```

All events are registered in a similar format. There are 4 main objects in each request, described in detail in the [next section](#parameter-breakdown).

| Parameter   | Required | Description |
| ----------- | -------- | ----------- |
| `user`      | Yes      | All data that we know about the current user at the time.
| `event`     | Yes      | Details about the event
| `context`   | No       | Details about the user’s device and location
| `timestamp` | No       | An ISO-8601 date string in UTC time for when the event happened

## Parameter breakdown

### User

| FieldName | Data Type   | Required               | Description |
| -------------- | ----------- | ---------------------- | ----------- |
| `user_id`      | String      | Yes (if logged in)     | The unique user id if the user has logged in
| `anonymous_id` | String      | Yes (if not logged in) | An automatically generated visitor id if the user has not logged in.
| `profile`      | JSON Object | No                     | Any user segmentation data you know about the user, see the table below for details.

<aside class="notice">
  If you send us both a <code>user_id</code> and <code>anonymous_id</code> we will record the <code>user_id</code>.
</aside>

#### User Profile (user.profile)

| FieldName | Data Type | Required | Description |
| ---------- | --------- | -------- | ----------- |
| `sex`      | String    | No       | Sex of the user
| `segment`  | String    | No       | Custom segment name that you store e.g. Gold class / Member
| `location` | String    | No       | Location of the user as a commune, city, region or country

The above are the most common types of profile segments, since it's a JSON object you can specify any other fields you wish to use for personalization.

### Event

Field descriptions differ per event type. Please refer to the event descriptions below to know what fields are required.

### Context (optional)

We use incoming HTTP headers to fill in this object, therefore this object is optional. You can specify context if you are sending historical data, or have any other special requirements that require overriding the default headers.

Refer to the example json on the right to view the format.

```json
  "context": {
    "ip": "12.34.56.78",
    "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  }
```

| FieldName   | Data Type | Required | Description |
| ------------ | --------- | -------- | ----------- |
| `ip`         | String    | No       | IP address
| `user_agent` | String    | No       | User agent string of the browser

### Timestamp (optional)

Only required if you're sending us historical events, if not, we log the event at the time we received it.

Refer to the example json on the right to view the format.

```json
  "timestamp": "2018-01-23 00:30:08.276Z"
```

| FieldName  | Data Type     | Required | Description |
| ----------- | ------------- | -------- | ----------- |
| `timestamp` | ISO-8601 Date | No       | The current time in UTC for when the event happened. E.g. `"2017-11-01 00:29:03.123Z"`

## Cart update

```javascript--browser
// assign user_id and user.profile if you haven't yet
window.datacue.identify('019mr8mf4r', {
  sex: 'female',
  location: 'Santiago',
  segment: 'platinum'
});

// track the event
window.datacue.track({
  type: 'cart',
  subtype: 'update',
  cart: [{
    product_id: 'p1',
    variant_id: 'v1',
    quantity: 1,
    unit_price: 24,
    currency: 'USD'
  },{
    product_id: 'p2',
    variant_id: 'v1',
    quantity: 1,
    unit_price: 24,
    currency: 'USD'
  },{
    product_id: 'p3',
    variant_id: 'v1',
    quantity: 1,
    unit_price: 24,
    currency: 'USD'
  }],
  cart_link:'https://myshop.com/cart/123'
});
```

```php
<?php
"browser only event (refer to the Browser tab)"
```

```python
"browser only event (refer to the Browser tab)"
```

```javascript--node
"browser only event (refer to the Browser tab)"
```

> The above command returns a 204 response code

Record whenever the users shopping cart changes. Whenever the user:

- Adds a product to the cart
- Removes a product from the cart
- Updates a product in the cart (e.g. changes quantity)
- Clears the cart

### Request parameters

| FieldName  | Data Type | Required | Description |
| ------ | --------- | -------- | ----------- |
| `type`     | String    | Yes      | Set to `'cart'`
| `subtype`  | String    | Yes      | Set to `'update'`
| `cart`     | Array     | Yes      | Cart contents as an array of product, variant, unit price, quantity and currency
| `cart_link`  | String    | Yes      | Link to view cart and resume shopping

## Add product to wishlist

```javascript--browser
// assign user_id and user.profile if you haven't yet
window.datacue.identify('019mr8mf4r', {
  sex: 'female',
  location: 'Santiago',
  segment: 'platinum'
});

// track the event
window.datacue.track({
  type: 'wishlist',
  subtype: 'add',
  product_id: 'p1',
  variant_id: 'v2'
});
```

```php
<?php
"browser only event (refer to the Browser tab)"
```

```python
"browser only event (refer to the Browser tab)"
```

```javascript--node
"browser only event (refer to the Browser tab)"
```

> The above command returns a 204 response code

Record changes to user's wishlist when a new product is added to it.

### Request parameters

| FieldName   | Data Type | Required | Description |
| ------------ | --------- | -------- | ----------- |
| `type`       | String    | Yes      | Set to `'wishlist'`
| `subtype`    | String    | Yes      | Set to `'add'`
| `product_id` | String    | Yes      | Set to product id being added
| `variant_id` | String    | No       | Set to product's variant id (if applicable)

## Remove product from wishlist

```javascript--browser
// assign user_id and user.profile if you haven't yet
window.datacue.identify('019mr8mf4r', {
  sex: 'female',
  location: 'Santiago',
  segment: 'platinum'
});

// track the event
window.datacue.track({
  type: 'wishlist',
  subtype: 'remove',
  product_id: 'p1',
  variant_id: 'v2'
});
```

```php
<?php
"browser only event (refer to the Browser tab)"
```

```python
"browser only event (refer to the Browser tab)"
```

```javascript--node
"browser only event (refer to the Browser tab)"
```

> The above command returns a 204 response code

Record changes to user's wishlist when a product is removed from it.

### Request parameters

| FieldName   | Data Type | Required | Description |
| ------------ | --------- | -------- | ----------- |
| `type`       | String    | Yes      | Set to `'wishlist'`
| `subtype`    | String    | Yes      | Set to `'remove'`
| `product_id` | String    | Yes      | Set to product id being removed
| `variant_id` | String    | No       | Set to product's variant id (if applicable)

## Checkout started

```javascript--browser
// assign user_id and user.profile if you haven't yet
window.datacue.identify('019mr8mf4r', {
  sex: 'female',
  location: 'Santiago',
  segment: 'platinum'
});

// track the event
window.datacue.track({
  type: 'checkout',
  subtype: 'started',
  cart: [{
    product_id: 'p1',
    variant: 'v1',
    quantity: 1,
    unit_price: 24,
    currency: 'USD'
  },{
    product_id: 'p2',
    variant: 'v2',
    quantity: 3,
    unit_price: 39,
    currency: 'USD'
  }],
  cart_link:'https://myshop.com/cart/123'
});
```

```php
<?php
"browser only event (refer to the Browser tab)"
```

```python
"browser only event (refer to the Browser tab)"
```

```javascript--node
"browser only event (refer to the Browser tab)"
```

> The above command returns a 204 response code

Record the moment the user initiates the check out process, typically from their shopping cart.

### Request parameters

| FieldName | Data Type | Required | Description |
| ---------- | --------- | -------- | ----------- |
| `type`     | String    | Yes      | Set to `'checkout'`
| `subtype`  | String    | Yes      | Set to `'started'`
| `cart`     | Array     | Yes      | Cart contents as an array of product, variant, unit price, quantity and currency
| `cart_link`  | String    | Yes      | Link to view cart and resume shopping

## User Login

```javascript--browser
// assign user_id and user.profile if you haven't yet
window.datacue.identify('019mr8mf4r', {
  sex: 'female',
  location: 'Santiago',
  segment: 'platinum'
});

// track the event
window.datacue.track({
  type: 'login'
});
```

```php
<?php
"browser only event (refer to the Browser tab)"
```

```python
"browser only event (refer to the Browser tab)"
```

```javascript--node
"browser only event (refer to the Browser tab)"
```

> The above command returns a 204 response code

Record a login event by a user on your website, if the user login is cached, you do not need to fire this event when the user returns.

### Request parameters

| FieldName | Data Type | Required | Description |
| ------ | --------- | -------- | ----------- |
| `type` | String    | Yes      | Set to `'login'`

# Optional Events

You don't need to implement those if you're using our scripts.


## Home pageview

```javascript--browser
// assign user_id and user.profile if you haven't yet
window.datacue.identify('019mr8mf4r', {
  sex: 'female',
  location: 'Santiago',
  segment: 'platinum'
});

// track the event
window.datacue.track({
  type: 'pageview',
  subtype: 'home'
}).then(function(response) {
  // see response structure below
});
```

```php
<?php
"browser only event (refer to the Browser tab)"
```

```python
"browser only event (refer to the Browser tab)"
```

```javascript--node
"browser only event (refer to the Browser tab)"
```

> The above command returns JSON structured like this:

```json
{
  "main_banners": [
    {
      "link": "/category/bathroom",
      "name": "",
      "banner_id": "B1",
      "photo_url": "/banners/bathroom/bathroom-min.jpeg"
    }
  ],
  "sub_banners": [
    {
      "link": "/category/bathroom/organizer",
      "name": "",
      "banner_id": "B6",
      "photo_url": "/banners/bathroom/subbanner_organizer.jpeg"
    },
    {
      "link": "/category/bathroom/racks",
      "name": "",
      "banner_id": "B7",
      "photo_url": "/banners/bathroom/subbanner_racks.jpeg"
    },
    {
      "link": "/category/bathroom/towels",
      "name": "",
      "banner_id": "B8",
      "photo_url": "/banners/bathroom/subbanner_towels.jpeg"
    }
  ],
  "related_product_skus": [
    {
      "link": "/product/double-bed-2",
      "name": "Luxury Double Bed",
      "price": 1299,
      "photo_url": "/products/18.jpg",
      "category_1": "bedroom",
      "product_id": "18"
    },
    {
      "link": "/product/sofa-4",
      "name": "Contemporary Sofa",
      "price": 329,
      "photo_url": "/products/59.jpg",
      "category_1": "living-room",
      "product_id": "59"
    },
    {
      "link": "/product/cutleries-2",
      "name": "Decorative Flatware",
      "price": 79,
      "photo_url": "/products/41.jpg",
      "category_1": "kitchen",
      "product_id": "41"
    },
    {
      "link": "/product/organizer-4",
      "name": "Scandinavian Organizer",
      "price": 69,
      "photo_url": "/products/12.jpg",
      "category_1": "bathroom",
      "product_id": "12"
    }
  ],
  "recent_product_skus": [
    {
      "product_id": "18",
      "variant_id": "a",
      "name": "Luxury Double Bed",
      "price": "1299.00",
      "photo_url": "/products/18.jpg",
      "link": "/product/double-bed-2",
      "extra": {
        "discount":"20%"
      }
    }
  ]
}
```

Request banner and product recommendations when a user visits your home page

### Request parameters

| FieldName | Data Type | Required | Description |
| --------- | --------- | -------- | ----------- |
| `type`    | String    | Yes      | Set to `'pageview'`
| `subtype` | String    | Yes      | Set to `'home'`

### Response JSON

| FieldName             | Data Type | Description |
| ---------------------- | --------- | ----------- |
| `main_banners`         | Array     | An array of banner objects recommended for the current user
| `sub_banners`          | Array     | An array of sub banner objects recommended for the current user
| `related_product_skus` | Array     | An array of product objects recommended for the current user
| `recent_product_skus`  | Array     | A live list of the last products the current user has viewed

## Product pageview

```javascript--browser
// assign user_id and user.profile if you haven't yet
window.datacue.identify('019mr8mf4r', {
  sex: 'female',
  location: 'Santiago',
  segment: 'platinum'
});

// track the event
window.datacue.track({
  type: 'pageview',
  subtype: 'product',
  product_id: 'p1',
  variant_id: 'v1'
}).then(function(response) {
  // see response structure below
});
```

```php
<?php
"browser only event (refer to the Browser tab)"
```

```python
"browser only event (refer to the Browser tab)"
```

```javascript--node
"browser only event (refer to the Browser tab)"
```

> The above command returns JSON structured like this:

```json
{
  "similar_product_skus": [
    {
      "link": "/product/sofa-1",
      "name": "Soft Sofa",
      "price": 299,
      "photo_url": "/products/56.jpg",
      "category_1": "living-room",
      "product_id": "56"
    },
    {
      "link": "/product/outdoor-sofa-3",
      "name": "Wicker Sofa",
      "price": 299,
      "photo_url": "/products/38.jpg",
      "category_1": "outdoors",
      "product_id": "38"
    },
    {
      "link": "/product/single-bed-1",
      "name": "Basic Bed",
      "price": 299,
      "photo_url": "/products/16.jpg",
      "category_1": "bedroom",
      "product_id": "16"
    },
    {
      "link": "/product/rack-2",
      "name": "Handicraft Rack",
      "price": 49,
      "photo_url": "/products/6.jpg",
      "category_1": "bathroom",
      "product_id": "6"
    }
  ],
  "related_product_skus": null,
  "recent_product_skus": [
    {
      "product_id": "18",
      "variant_id": "a",
      "name": "Luxury Double Bed",
      "price": "1299.00",
      "photo_url": "/products/18.jpg",
      "link": "/product/double-bed-2",
      "extra": {
      }
    }
  ]
}
```

Request product recommendations when a user visits a product page

### Request parameters

| FieldName   | Data Type | Required | Description |
| ------------ | --------- | -------- | ----------- |
| `type`       | String    | Yes      | Set to `'pageview'`
| `subtype`    | String    | Yes      | Set to `'product'`
| `product_id` | String    | Yes      | Set to product id being viewed
| `variant_id` | String    | No       | Set to product's variant id (if applicable)

### Response JSON

| FieldName             | Data Type | Description |
| ---------------------- | --------- | ----------- |
| `similar_product_skus` | Array     | An array of product objects with similar characteristics to the current product
| `related_product_skus` | Array     | An array of product objects that are frequently bought with the current product
| `recent_product_skus`  | Array     | A live list of the last products the current user has viewed

## Category pageview

```javascript--browser
// assign user_id and user.profile if you haven't yet
window.datacue.identify('019mr8mf4r', {
  sex: 'female',
  location: 'Santiago',
  segment: 'platinum'
});

// track the event
window.datacue.track({
  type: 'pageview',
  subtype: 'category',
  category_name: 'living-room'
});
```

```php
<?php
"browser only event (refer to the Browser tab)"
```

```python
"browser only event (refer to the Browser tab)"
```

```javascript--node
"browser only event (refer to the Browser tab)"
```

> The above command returns a 204 response code

Pages showing multiple products on a page, these are commonly called category, collection or catalog pages.

### Request parameters

| FieldName      | Data Type | Required | Description |
| --------------- | --------- | -------- | ----------- |
| `type`          | String    | Yes      | Set to `'pageview'`
| `subtype`       | String    | Yes      | Set to `'category'`
| `category_name` | String    | Yes      | Set to the name of the category being viewed

## Search

```javascript--browser
// assign user_id and user.profile if you haven't yet
window.datacue.identify('019mr8mf4r', {
  sex: 'female',
  location: 'Santiago',
  segment: 'platinum'
});

// track the event
window.datacue.track({
  type: 'search',
  term: 'tables'
}).then(function(response) {
  // see response structure below
});
```

```php
<?php
"browser only event (refer to the Browser tab)"
```

```python
"browser only event (refer to the Browser tab)"
```

```javascript--node
"browser only event (refer to the Browser tab)"
```

> The above command returns JSON structured like this:

```json
{
  "recent_product_skus": [
    {
      "product_id": "18",
      "variant_id": "a",
      "name": "Luxury Double Bed",
      "price": "1299.00",
      "photo_url": "/products/18.jpg",
      "link": "/product/double-bed-2",
      "extra": {
        "discount":"20%"
      }
    }
  ]
}
```

Record when a user performs a search on your website

### Request parameters

| FieldName | Data Type | Required | Description |
| ------ | --------- | -------- | ----------- |
| `type` | String    | Yes      | Set to `'search'`
| `term` | String    | Yes      | Set to the user's search term

### Response JSON

| FieldName            | Data Type | Description |
| --------------------- | --------- | ----------- |
| `recent_product_skus` | Array     | A live list of the last products the current user has viewed

## Banner click

```javascript--browser
// assign user_id and user.profile if you haven't yet
window.datacue.identify('019mr8mf4r', {
  sex: 'female',
  location: 'Santiago',
  segment: 'platinum'
});

// track the event
// NOTE: passing true as 2nd argument will defer
// the event until next page load (helpful if your
// shop is not a single page app)
window.datacue.track({
  type: 'click',
  subtype: 'banner',
  banner_id: 'b1'
}, true);
```

```php
<?php
"browser only event (refer to the Browser tab)"
```

```python
"browser only event (refer to the Browser tab)"
```

```javascript--node
"browser only event (refer to the Browser tab)"
```

> The above command returns a 204 response code

Record clicks to a banner or a sub banner, typically on your home page

### Request parameters

| FieldName  | Data Type | Required | Description |
| ----------- | --------- | -------- | ----------- |
| `type`      | String    | Yes      | Set to `'click'`
| `subtype`   | String    | Yes      | Set to `'banner'`
| `banner_id` | String    | Yes      | Set to the id of the clicked banner

## Product click

```javascript--browser
// assign user_id and user.profile if you haven't yet
window.datacue.identify('019mr8mf4r', {
  sex: 'female',
  location: 'Santiago',
  segment: 'platinum'
});

// track the event
// NOTE: passing true as 2nd argument will defer
// the event until next page load (helpful if your
// shop is not a single page app)
window.datacue.track({
  type: 'click',
  subtype: 'product',
  product_id: 'p2'
}, true);
```

```php
<?php
"browser only event (refer to the Browser tab)"
```

```python
"browser only event (refer to the Browser tab)"
```

```javascript--node
"browser only event (refer to the Browser tab)"
```

> The above command returns a 204 response code

Record clicks on a product anywhere on your website.

### Request parameters

| FieldName   | Data Type | Required | Description |
| ------------ | --------- | -------- | ----------- |
| `type`       | String    | Yes      | Set to `'click'`
| `subtype`    | String    | Yes      | Set to `'related'`, `'similar'` or `'recent'`
| `product_id` | String    | Yes      | Set to the id of the clicked product

# Products

## Create Product

```javascript--browser
"backend only event (refer to the Python, PHP or Node tab)"
```

```php
<?php

$apikey = "Your-API-Key-goes-here";
$apisecret = "Your-API-secret-goes-here";

$datacue = new \DataCue\Client($apikey, $apisecret);

$data = [
  "product_id" => "p1",
  "variant_id" => "v1",
  "main_category" => "jeans",
  "categories" => ["men","summer","jeans"],
  "name" => "cool jeans",
  "brand" => "zara",
  "description" => "very fashionable jeans",
  "color" => "blue",
  "size" => "M",
  "price" => 25000,
  "full_price" => 30000,
  "available" => True,
  "stock" => 5,
  "extra" => [
    "extra_feature" => "details"
  ],
  "photo_url" => "https://s3.amazon.com/image.png",
  "link" => "/product/p1",
  "owner_id" => "user_id_3"
];

$res = $datacue->products->create($data);

?>
```

```python

import hashlib
import hmac
import json
import requests

url = "https://api.datacue.co/v1/products"
apikey = "your-api-key-goes-here"
apisecret = "your-api-secret-goes-here"

data = {
  "product_id": "p1",
  "variant_id": "v1",
  "main_category": "jeans",
  "categories": ["men","summer","jeans"],
  "name": "cool jeans",
  "brand": "zara",
  "description": "very fashionable jeans",
  "color": "blue",
  "size": "M",
  "price": 25000,
  "full_price": 35000,
  "available": True,
  "stock": 5,
  "extra": {
    "extra_feature": "details"
  },
  "photo_url": "https://s3.amazon.com/image.png",
  "link": "/product/p1",
  "owner_id": "user_id_3"
}



checksum = hmac.new(bytes(apisecret,'utf-8'), bytes(json.dumps(data)), 'utf-8'), hashlib.sha256)


headers = {
"Content-type": "application/json",
}

response = requests.post(url, json=data, auth=(apikey, checksum.hexdigest())

```

```javascript--node
const axios = require('axios');
const cryto = require('crypto');

const url = 'https://api.datacue.co/v1/products'
const apikey = 'your-api-key-goes-here';
const apisecret = 'your-api-secret-goes-here';

const data = {
  product_id: 'p1',
  variant_id: 'v1',
  main_category: 'jeans',
  categories: ['men','summer','jeans'],
  name: 'cool jeans',
  brand: 'zara',
  description: 'very fashionable jeans',
  color: 'blue',
  size: 'M',
  price: 25000,
  full_price: 35000,
  available: true,
  stock: 5,
  extra: {
    extra_feature: 'details'
  },
  photo_url: 'https://s3.amazon.com/image.png',
  link: '/product/p1',
  owner_id: 'user_id_3'
};

var hash = crypto.createHmac('sha256', apisecret).update(JSON.Stringify(data));

//add to default authentication header
axios.defaults.auth = { username: 'API-key', password: hash.digest('hex') };

axios.post(url, data);
```

> The above command returns a 201 response code

Endpoint: `POST` `https://api.datacue.co/v1/products`
Whenever a new product is created, send this request from your backend.

### Request parameters

| FieldName       | Data Type   | Required | Description |
| ---------------- | ----------- | -------- | ----------- |
| `product_id`     | String      | Yes      | The product id or SKU number
| `variant_id`     | String      | Yes      | A unique variant id within the product id, if you only use product SKUs set this to a constant such as 'no-variants'
| `main_category`  | String   | Yes   | The most specific category for the product e.g. 'Jeans'.
| `categories`     | String Array| Yes       | A list of all the matching categories as tags e.g. ["Jeans","Summer","Men"]
| `name`           | String      | Yes      | Name or Title of the product
| `brand`          | String      | No       | Brand name of the product
| `description`    | String      | No       | Long text description of the product
| `color`          | String      | No       | Color of the product
| `size`           | String      | No       | Size of the product
| `price`          | Decimal     | Yes      | Current price including any discounts to two decimal places e.g. 4.50
| `full_price`          | Decimal     | Yes      | Full price without discount to two decimal places e.g. 5.30
| `available`      | Boolean     | No       | Is the product available for Sale (Default true)
| `stock`          | Integer     | Yes      | Number of product in stock
| `extra`          | JSON Object | No       | Any other fields you want to store about the product that you want to display on site e.g. discounts or promotions.
| `photo_url`      | String      | Yes      | URL of the photo, you can use relative URLs as this is purely for your front-end to request the image
| `link`           | String      | Yes      | URL of product page for this product e.g. /products/p1
| `owner_id`       | String      | No       | If you're running a marketplace, store the product's owner or seller's user ID here.

#### Discounts
DataCue can feature your discounted products automatically. Use the `price` and `full_price` field when you have a discount. If `full_price` is empty or less than `price`, we assume the product is not on discount.

Lets say you have a product that usually costs $50. This week you have it's on discount and costs $40.
Update the product like so:
- `price` = 40.00
- `full_price` = 50.00

## Update Product

```javascript--browser
"backend only event (refer to the Python, PHP or Node tab)"
```

```php
<?php

$apikey = "Your-API-Key-goes-here";
$apisecret = "Your-API-secret-goes-here";

$datacue = new \DataCue\Client($apikey, $apisecret);

// replace $productId with the actual values you want to update
$productId = "p1";
// replace $variantId with the actual values you want to update
$variantId = "v1";
$data = [
  "main_category" => "shorts",
  "categories" => ["shorts","men"],
  "stock" => 6,
  "available" => false
];

$res = $datacue->products->update($productId, $variantId, $data);

```

```python

import hashlib
import hmac
import json
import requests

url = "https://api.datacue.co/v1/products/:product_id/:variant_id"
apikey = "your-api-key-goes-here"
apisecret = "your-api-secret-goes-here"

data = {
  "main_category" : "shorts",
  "categories" : ["shorts","men"],
  "stock": 6,
  "available": False
}

checksum = hmac.new(bytes(apisecret,'utf-8'), bytes(json.dumps(data)), 'utf-8'), hashlib.sha256)

response = requests.put(url, data=data, auth=(apikey, checksum.hexdigest())

```

```javascript--node
const axios = require('axios');
const cryto = require('crypto');

const url = `https://api.datacue.co/v1/products/${productId}/${variantId}`
const apikey = 'your-api-key-goes-here';
const apisecret = 'your-api-secret-goes-here';

const data = {
  main_category: 'shorts',
  categories: ['shorts','men"],
  stock: 6,
  available: false
};

var hash = crypto.createHmac('sha256', apisecret).update(JSON.Stringify(data));

//add to default authentication header
axios.defaults.auth = { username: apikey, password: hash.digest('hex') };

axios.put(url, data);
```

> The above command returns a 204 response code

Endpoint: `PUT` `https://api.datacue.co/v1/products/<product_id>/<variant_id>`

Whenever an existing product is updated such as image, name, price or new discounts, send this request from your backend.

### Request parameters

Same as for [Create Product](#create-product), except `product_id` and `variant_id`.

<aside class="success">
  Remember that when an order is completed this is also a product update as the stock level of the product will change. Sending us a product update after an order will ensure that if a product is out of stock, it is no longer recommended to other users.
</aside>

## Delete Product

```javascript--browser
"backend only event (refer to the Python, PHP or Node tab)"
```

```php
<?php

$apikey = "Your-API-Key-goes-here";
$apisecret = "Your-API-secret-goes-here";

$datacue = new \DataCue\Client($apikey, $apisecret);

// replace $productId with the actual value you want to delete
$productId = "p1";
// replace $variantId with the actual value you want to delete
$variantId = "v1";

// if you want to delete a variant
$res = $datacue->products->delete($productId, $variantId);

// if you want to delete a product and all associated variants
$res = $datacue->products->delete($productId);

```

```python

import hashlib
import hmac
import json
import requests

url = "https://api.datacue.co/v1/products/:product_id/:variant_id"

apikey = "your-api-key-goes-here"
apisecret = "your-api-secret-goes-here"

checksum = hmac.new(bytes(apisecret,'utf-8'), bytes(""), 'utf-8'), hashlib.sha256)

response = requests.delete(url, auth=(apikey, checksum.hexdigest()))
```

```javascript--node
const axios = require('axios');
const cryto = require('crypto');

const url = `https://api.datacue.co/v1/products/${productId}/${variantId}`
const apikey = 'your-api-key-goes-here';
const apisecret = 'your-api-secret-goes-here';

var hash = crypto.createHmac('sha256', apisecret).update('');

//add to default authentication header
axios.defaults.auth = { username: apikey, password: hash.digest('hex') };

axios.delete(url);
```

> The above command returns a 204 response code

Delete a product on your system.

### Delete a variant

Endpoint: `DELETE` `https://api.datacue.co/v1/products/<product_id>/<variant_id>`

### Delete a product and all associated variants

Endpoint: `DELETE` `https://api.datacue.co/v1/products/<product_id>`

# Users

## Create User

```javascript--browser
"backend only event (refer to the Python, PHP or Node tab)"
```

```php
<?php

$apikey = "Your-API-Key-goes-here";
$apisecret = "Your-API-secret-goes-here";

$datacue = new \DataCue\Client($apikey, $apisecret);

$data = [
  "user_id" => "u1",
  "email" => "xyz@abc.com",
  "title" => "Mr",
  "first_name" => "John",
  "last_name" => "Smith",
  "profile" => [
    "location" => "santiago",
    "sex" => "male",
    "segment" => "platinum"
  ],
  "wishlist" => ["P1", "P3", "P4"], //array of product ids
  "email_subscriber" => true,
  "timestamp" => "2018-04-04 23:29:04-03:00"
];

$res = $datacue->users->create($data);

```

```python
import hashlib
import hmac
import json
import requests

url = "https://api.datacue.co/v1/users"
apikey = "your-api-key-goes-here"
apisecret = "your-api-secret-goes-here"

data = {
  "user_id": "u1",
  "email": "xyz@abc.com",
  "title": "Mr",
  "first_name": "John",
  "last_name": "Smith",
  "profile": {
    "location": "santiago",
    "sex": "male",
    "segment": "platinum"
  },
  "wishlist": ['P1','P3','P4'], #array of product ids
  "email_subscriber": True,
  "timestamp": "2018-04-04 23:29:04-03:00"
}


checksum = hmac.new(bytes(apisecret,'utf-8'), bytes(json.dumps(data)), 'utf-8'), hashlib.sha256)

response = requests.post(url, json=data, auth=(apikey, checksum.hexdigest())

```

```javascript--node
const axios = require('axios');
const cryto = require('crypto');

const url = 'https://api.datacue.co/v1/users'
const apikey = 'your-api-key-goes-here';
const apisecret = 'your-api-secret-goes-here';

const data = {
  user_id: 'u1',
  email: 'xyz@abc.com',
  title: 'Mr',
  first_name: 'Noob',
  last_name: 'Saibot',
  profile: {
    location: 'santiago',
    sex: 'male',
    segment: 'platinum'
  },
  wishlist: ['P1','P3','P4'], //array of product ids
  email_subscriber: true,
  timestamp: '2018-04-04 23:29:04-03:00'
};

var hash = crypto.createHmac('sha256', apisecret).update(JSON.Stringify(data));

//add to default authentication header
axios.defaults.auth = { username: 'API-key', password: hash.digest('hex') };

axios.post(url, data);
```

> The above command returns a 201 response code

Endpoint: `POST` `https://api.datacue.co/v1/users`

When a new user has successfully signed up / registered on your system.

### Request parameters

| FieldName | Data Type     | Required                      | Description |
| ------------------ | ------------- | ----------------------------- | ----------- |
| `user_id`          | String        | Yes                           | The unique user id assigned
| `anonymous_id`     | String        | No                            | Anonymous ID that was previously associated with this user prior to user sign up
| `email`            | String        | Yes, if using email marketing | User's email address
| `title`            | String        | No                            | Salutation e.g. Mr., Ms., Dr.
| `first_name`       | String        | Yes                           | User's first name, if you store all the names in one field assign the name to this field
| `last_name`        | String        | No                            | User's last name
| `profile`          | JSON Object   | No                            | User's profile. See table below for field description
| `email_subscriber` | Boolean       | No                            | Has this user consented to receive marketing email?
| `wishlist`         | Array         | No                            | An array of product ids representing the products the user has on their wishlist.
| `timestamp`        | ISO-8601 Date | No                            | User creation date/time in UTC timezone

### profile

| FieldName | Data Type | Required | Description |
| ---------- | --------- | -------- | ----------- |
| `sex`      | String    | No       | Sex of the user
| `segment`  | String    | No       | Custom segment name that you store e.g. Gold class / Member
| `location` | String    | No       | Location of the user as a commune, city, region or country

## Update User

```javascript--browser
"backend only event (refer to the Python, PHP or Node tab)"
```

```php
<?php

$apikey = "Your-API-Key-goes-here";
$apisecret = "Your-API-secret-goes-here";

$datacue = new \DataCue\Client($apikey, $apisecret);

// replace $userId with the actual value you want to update
$userId = "u1";
$data = [
  "profile" => [
    "location" => "singapore"
  ]
];

$res = $datacue->users->update($userId, $data);

```

```python
import hashlib
import hmac
import json
import requests

url = "https://api.datacue.co/v1/users/:user_id"
apikey = "your-api-key-goes-here"
apisecret = "your-api-secret-goes-here"

data = {
  "profile": {
    "location": "singapore"
  }
}

checksum = hmac.new(bytes(apisecret,'utf-8'), bytes(json.dumps(data)), 'utf-8'), hashlib.sha256)

response = requests.put(url, data=data, auth=(apikey, checksum.hexdigest())
```

```javascript--node
const axios = require('axios');
const cryto = require('crypto');

const url = `https://api.datacue.co/v1/users/${userId}`
const apikey = 'your-api-key-goes-here';
const apisecret = 'your-api-secret-goes-here';

const data = {
  profile: {
    location: 'singapore'
  }
};

var hash = crypto.createHmac('sha256', apisecret).update(JSON.Stringify(data));

//add to default authentication header
axios.defaults.auth = { username: apikey, password: hash.digest('hex') };

axios.put(url, data);
```

> The above command returns a 204 response code

Endpoint: `PUT` `https://api.datacue.co/v1/users/<user_id>`

When the user makes changes to their profile or when they configure any relevant preferences. For instance if they indicate their gender, this is very helpful for recommendations.

### Request parameters

Same as for [Create User](#create-user), except `user_id`.

## Delete User

```javascript--browser
"backend only event (refer to the Python, PHP or Node tab)"
```

```php
<?php

$apikey = "Your-API-Key-goes-here";
$apisecret = "Your-API-secret-goes-here";

$datacue = new \DataCue\Client($apikey, $apisecret);

// replace $userId with the actual value you want to delete
$userId = "u1";

$res = $datacue->users->delete($userId);

```

```python
import hashlib
import hmac
import json
import requests

url = "https://api.datacue.co/v1/users/:user_id"
apikey = "your-api-key-goes-here"
apisecret = "your-api-secret-goes-here"

checksum = hmac.new(bytes(apisecret,'utf-8'), bytes(""), 'utf-8'), hashlib.sha256)

response = requests.delete(url, auth=(apikey, checksum.hexdigest()))

```

```javascript--node
const axios = require('axios');
const cryto = require('crypto');

const url = `https://api.datacue.co/v1/users/${userId}`
const apikey = 'your-api-key-goes-here';
const apisecret = 'your-api-secret-goes-here';

var hash = crypto.createHmac('sha256', apisecret).update('');

//add to default authentication header
axios.defaults.auth = { username: apikey, password: hash.digest('hex') };

axios.delete(url);

```

> The above command returns a 204 response code

Endpoint: `DELETE` `https://api.datacue.co/v1/users/<user_id>`

When a user account is deleted from your system.

# Orders

## Create Order

```javascript--browser
"backend only event (refer to the Python, PHP or Node tab)"
```

```php
<?php

$apikey = "Your-API-Key-goes-here";
$apisecret = "Your-API-secret-goes-here";

$datacue = new \DataCue\Client($apikey, $apisecret);

$data = [
  "order_id" => "O123",
  "user_id" => "U456",
  "cart" => [
    ["product_id" => "p1", "variant_id" => "v1", "quantity" => 1, "unit_price" => 24, "currency" => "USD"],
    ["product_id" => "p3", "variant_id" => "v2", "quantity" => 9, "unit_price" => 42, "currency" => "USD"]
  ],
  "timestamp" => "2018-04-04 23:29:04Z"
];

$res = $datacue->orders->create($data);

```

```python
import hashlib
import hmac
import json
import requests

url = "https://api.datacue.co/v1/orders"
apikey = "your-api-key-goes-here"
apisecret = "your-api-secret-goes-here"

data = {
  "order_id": "o123",
  "user_id": "u456",
  "cart": [
    {
      "product_id": "p1",
      "variant_id": "v1",
      "quantity": 1,
      "unit_price": 24,
      "currency": "USD"
    },
    {
      "product_id": "p3",
      "variant_id": "v2",
      "quantity": 9,
      "unit_price": 42,
      "currency": "USD"
    }
  ],
  "timestamp": "2018-04-04 23:29:04Z"
}

checksum = hmac.new(bytes(apisecret,'utf-8'), bytes(json.dumps(data)), 'utf-8'), hashlib.sha256)

response = requests.post(url, json=data, auth=(apikey, checksum.hexdigest())
```

```javascript--node
const axios = require('axios');
const cryto = require('crypto');

const url = 'https://api.datacue.co/v1/orders'
const apikey = 'your-api-key-goes-here';
const apisecret = 'your-api-secret-goes-here';

const data = {
  order_id : 'O123',
  user_id : 'U456',
  order_status : 'completed',
  cart: [
    {
      product_id : 'p1',
      variant_id : 'v1',
      quantity : 1,
      unit_price : 24,
      currency : 'USD'
    },
    {
      product_id : 'p3',
      variant_id : 'v2',
      quantity : 9,
      unit_price : 42,
      currency : 'USD'
    }
  ],
  timestamp: '2018-04-04 23:29:04Z'
}

var hash = crypto.createHmac('sha256', apisecret).update(JSON.Stringify(data));

//add to default authentication header
axios.defaults.auth = { username: 'API-key', password: hash.digest('hex') };

axios.post(url, data);
```

> The above command returns a 201 response code

Endpoint: `POST` `https://api.datacue.co/v1/orders`

When a user has successfully completed an order on your store. An Order is considered 'completed' as soon as the checkout process is completed on your website. It does not matter if the order has further steps such as waiting for payment, or order fulfilment.

### Request parameters

| FieldName | Data Type     | Required                      | Description |
| ------------------ | ------------- | ----------------------------- | ----------- |
| `order_id`         | String        | Yes                           | The unique order id assigned
| `user_id`          | String        | Yes                           | User ID that made the order
| `order_status`          | String        | No                           | Can be `completed` (default) or `cancelled`
| `cart`             | Array         | No                            | An array of line items in the order shopping cart
| `timestamp`        | ISO-8601 Date | No                            | Order creation date/time in UTC timezone

### cart items

| FieldName | Data Type | Required | Description |
| ---------- | --------- | -------- | ----------- |
| `product_id`      | String    | Yes       | Product ID code
| `variant_id`  | String    | Yes       | Variant ID of the product
| `unit_price` | Decimal    | Yes       | The unit price of the product (including any discounts)
| `quantity` | Integer    | Yes       | Number of products purchased

## Cancel Order

```javascript--browser
"backend only event (refer to the Python, PHP or Node tab)"
```

```php
<?php

$apikey = "Your-API-Key-goes-here";
$apisecret = "Your-API-secret-goes-here";

$datacue = new \DataCue\Client($apikey, $apisecret);

// replace $orderId with the actual value you want to cancel
$orderId = 'o1';

$res = $datacue->orders->cancel($orderId);

```

```python
import hashlib
import hmac
import json
import requests

url = "https://api.datacue.co/v1/orders/:order_id"
apikey = "your-api-key-goes-here"
apisecret = "your-api-secret-goes-here"

data = {
  "order_status": "cancelled"
}

checksum = hmac.new(bytes(apisecret,'utf-8'), bytes(json.dumps(data)), 'utf-8'), hashlib.sha256)

response = requests.put(url, data=data, auth=(apikey, checksum.hexdigest())
```

```javascript--node
const axios = require('axios');
const cryto = require('crypto');

const url = `https://api.datacue.co/v1/orders/${orderId}`
const apikey = 'your-api-key-goes-here';
const apisecret = 'your-api-secret-goes-here';

const data = {
  'order_status': 'cancelled'
}

var hash = crypto.createHmac('sha256', apisecret).update(JSON.Stringify(data));

//add to default authentication header
axios.defaults.auth = { username: apikey, password: hash.digest('hex') };

axios.put(url, data);
```

> The above command returns a 204 response code

Endpoint: `PUT` `https://api.datacue.co/v1/orders/<order_id>`

When the order makes changes to their profile or when they configure any relevant preferences. For instance if they indicate their gender, this is very helpful for recommendations.

### Request parameters

| Field | Data Type     | Required                      | Description |
| ------------------ | ------------- | ----------------------------- | ----------- |
| `order_status`          | String        | Yes                           | Can be `completed` or `cancelled`

## Delete Order

```javascript--browser
"backend only event (refer to the Python, PHP or Node tab)"
```

```php
<?php

$apikey = "Your-API-Key-goes-here";
$apisecret = "Your-API-secret-goes-here";

$datacue = new \DataCue\Client($apikey, $apisecret);

// replace $orderId with the actual value you want to delete
$orderId = 'o1';

$res = $datacue->orders->delete($orderId);

```

```python
import hashlib
import hmac
import json
import requests

url = "https://api.datacue.co/v1/orders/:order_id"
apikey = "your-api-key-goes-here"
apisecret = "your-api-secret-goes-here"

checksum = hmac.new(bytes(apisecret,'utf-8'), bytes(""), 'utf-8'), hashlib.sha256)

response = requests.delete(url, auth=(apikey, checksum.hexdigest()))
```

```javascript--node
const axios = require('axios');
const cryto = require('crypto');

const url = `https://api.datacue.co/v1/orders/${orderId}`
const apikey = 'your-api-key-goes-here';
const apisecret = 'your-api-secret-goes-here';

var hash = crypto.createHmac('sha256', apisecret).update('');

//add to default authentication header
axios.defaults.auth = { username: apikey, password: hash.digest('hex') };

axios.delete(url);

```

> The above command returns a 204 response code

Endpoint: `DELETE` `https://api.datacue.co/v1/orders/<order_id>`

When an order is deleted from your system.

# Batch

> Best explained with an example: lets say you want to create 500 products in one go. As seen in the previous section, a product create payload looks like this:

```json
{
  "product_id": "P1",
  "variant_id": "V2",
  "category_1": "jeans",
  "price": 50,
  "photo_url": "/products/p1.jpg",
  "link": "/products/p1"
}
```

> To submit multiple, just send an array of product create requests in the batch field like so:

```json
{
  "batch": [{
    "product_id": "P1",
    "variant_id": "V2",
    "category_1": "jeans",
    "price": 50,
    "photo_url": "/products/p1.jpg",
    "link": "/products/p1"
  }, {
    "product_id": "P2",
    "variant_id": "V1",
    "category_1": "shirts",
    "price": 30,
    "photo_url": "/products/p2.jpg",
    "link": "/products/p2"
  }]
}
```

Use the batch endpoint if you want to do a bulk import, typically when you first start using DataCue and you want to add your historical orders, products or users.

Build an array of your requests in the `batch` field, we accept a maximum of 500 items per request.


## Batch Create Products

```javascript--browser
"backend only event (refer to the Python, PHP or Node tab)"
```

```php
<?php

$apikey = "Your-API-Key-goes-here";
$apisecret = "Your-API-secret-goes-here";

$datacue = new \DataCue\Client($apikey, $apisecret, $options, $env);

// batch create products
$productDataList = [
    [
        "product_id" => "p1",
        "variant_id" => "v1",
        "main_category" => "jeans",
        "categories" => ["jeans","men","summer"],
        "name" => "cool jeans",
        "brand" => "zara",
        "description" => "very fashionable jeans",
        "color" => "blue",
        "size" => "M",
        "price" => 99,
        "full_price" => 119,
        "stock" => 5,
        "extra" => [
            "extra_feature" => "details"
        ],
        "photo_url" => "https://s3.amazon.com/image.png",
        "link" => "/product/p1",
        "owner_id" => "user_id_3"
    ], [
        "product_id" => "p2",
        "variant_id" => "v2",
        "main_category" => "hats",
        "categories" => ["hats","women","summer"],
        "name" => "summer hat",
        "brand" => "zara",
        "description" => "very fashionable hat",
        "color" => "black",
        "size" => "",
        "price" => 24,
        "full_price" => 30,
        "stock" => 5,
        "extra" => [
            "extra_feature" => "details"
        ],
        "photo_url" => "https://s3.amazon.com/image.png",
        "link" => "/product/p2",
        "owner_id" => "user_id_3"
    ]
];
$res = $datacue->products->batchCreate($productDataList);

```

```python
import hashlib
import hmac
import json
import requests

url = "https://api.datacue.co/v1/batch/products"
apikey = "your-api-key-goes-here"
apisecret = "your-api-secret-goes-here"

data = {
  "batch": [
    {
      "product_id" : "p1",
      "variant_id" : "v1",
      "main_category" : "jeans",
      "categories" : ["jeans","men","summer"],
      "name" : "cool jeans",
      "brand" : "zara",
      "description" : "very fashionable jeans",
      "color" : "blue",
      "size" : "M",
      "price" : 99,
      "full_price" : 119,
      "stock" : 5,
      "extra" : {
          "extra_feature": "details"
      },
      "photo_url" : "https://s3.amazonaws.com/image.png",
      "link" : "/product/p1"
    }, {
      "product_id" : "p2",
      "variant_id" : "v2",
      "main_category" : "hats",
      "categories" : ["hats","women","summer"],
      "name" : "summer hat",
      "brand" : "zara",
      "description" : "very fashionable hat",
      "color" : "black",
      "size" : "",
      "price" : 24,
      "full_price" : 30,
      "stock" : 5,
      "extra" : {
          "extra_feature": "details"
      },
      "photo_url": "https://s3.amazonaws.com/image.png",
      "link": "/product/p2"
    }
  ]
}

checksum = hmac.new(bytes(apisecret,'utf-8'),
  bytes(json.dumps(data)), 'utf-8'),
  hashlib.sha256)

response = requests.post(url, json=data, auth=(apikey, checksum.hexdigest())
```

```javascript--node
const axios = require('axios');
const cryto = require('crypto');

const url = 'https://api.datacue.co/v1/batch/products';
const apikey = 'your-api-key-goes-here';
const apisecret = 'your-api-secret-goes-here';

const data = {
  batch: [
    {
      product_id : 'p1',
      variant_id : 'v1',
      main_category : 'jeans',
      categories : ['jeans','men','summer'],
      name : 'cool jeans',
      brand : 'zara',
      description : 'very fashionable jeans',
      color : 'blue',
      size : 'M',
      price : 99,
      full_price : 119,
      stock : 5,
      extra : {
          'extra_feature': 'details'
      },
      photo_url : 'https://s3.amazonaws.com/image.png',
      link : '/product/p1'
    }, {
      product_id : 'p2',
      variant_id : 'v2',
      main_category : 'hats',
      categories : ['hats','women','summer'],
      name : 'summer hat',
      brand : 'zara',
      description : 'very fashionable hat',
      color : 'black',
      size : '',
      price : 24,
      full_price : 30,
      stock : 5,
      extra : {
          'extra_feature': 'details'
      },
      photo_url: 'https://s3.amazonaws.com/image.png',
      link: '/product/p2'
    }
  ]
};

var hash = crypto.createHmac('sha256', apisecret).update(JSON.Stringify(data));

//add to default authentication header
axios.defaults.auth = { username: 'API-key', password: hash.digest('hex') };

axios.post(url, data);

```

Endpoint: `POST` `https://api.datacue.co/v1/batch/products`

### Request parameters

| FieldName | Data Type | Required | Description |
| ------- | --------- | -------- | ----------- |
| `batch` | Array     | Yes      | Array of products you are sending

### Response JSON

> The above command returns a 207 multi status response code

```json
{
    "status": [
        {
            "product_id": "p1",
            "status": "error",
            "error": "p1 already exists"
        },
        {
            "product_id": "p2",
            "status": "OK"
        }
    ]
}
```

We will send you a status for each item you sent, so you can handle and resend only items that had an error.

## Batch Create Orders

```javascript--browser
"backend only event (refer to the Python, PHP or Node tab)"
```

```php
<?php

$apikey = "Your-API-Key-goes-here";
$apisecret = "Your-API-secret-goes-here";

$datacue = new \DataCue\Client($apikey, $apisecret, $options, $env);

$orderDataList = [
    [
        "order_id" => "o1",
        "user_id" => "u1",
        "cart" => [
            ["product_id" => "p1", "variant_id" => "v1", "quantity" => 1, "unit_price" => 24, "currency" => "USD"],
            ["product_id" => "p2", "variant_id" => "v2", "quantity" => 9, "unit_price" => 42, "currency" => "USD"],
        ],
        "timestamp" => "2018-04-04 23:29:04Z",
    ], [
        "order_id" => "o2",
        "user_id" => "u1",
        "cart" => [
            ["product_id" => "p1", "variant_id" => "v1", "quantity" => 1, "unit_price" => 24, "currency" => "USD"],
            ["product_id" => "p2", "variant_id" => "v2", "quantity" => 9, "unit_price" => 42, "currency" => "USD"],
        ],
        "timestamp" => "2018-04-04 23:29:04Z",
    ]
];
$res = $datacue->orders->batchCreate($orderDataList);

```

```python
import hashlib
import hmac
import json
import requests

url = "https://api.datacue.co/v1/batch/orders"
apikey = "your-api-key-goes-here"
apisecret = "your-api-secret-goes-here"

data = {
  "batch": [
    {
      "order_id" : "o1",
      "user_id" : "u1",
      "cart" : [
          {"product_id":  "p1", "variant_id" : "v1", "quantity" : 1, "unit_price":  24, "currency" : "USD"},
          {"product_id":  "p2", "variant_id" : "v2", "quantity" : 9, "unit_price":  42, "currency" : "USD"},
      ],
      "timestamp": "2018-04-04 23:29:04Z",
    }, {
      "order_id" : "o2",
      "user_id" : "u1",
      "cart" : [
          {"product_id" : "p1", "variant_id" : "v1", "quantity" : 1, "unit_price" : 24, "currency" : "USD"},
          {"product_id" : "p2", "variant_id" : "v2", "quantity" : 9, "unit_price" : 42, "currency" : "USD"},
      ],
      "timestamp" : "2018-04-04 23:29:04Z",
    ]
}

checksum = hmac.new(bytes(apisecret,'utf-8'),
  bytes(json.dumps(data)), 'utf-8'),
  hashlib.sha256)

response = requests.post(url, json=data, auth=(apikey, checksum.hexdigest())
```

```javascript--node
const axios = require('axios');
const cryto = require('crypto');

const url = 'https://api.datacue.co/v1/batch/orders';
const apikey = 'your-api-key-goes-here';
const apisecret = 'your-api-secret-goes-here';

const data = {
  batch: [
    {
      order_id : 'o1',
      user_id : 'u1',
      cart : [
          {'product_id':  'p1', 'variant_id' : 'v1', 'quantity' : 1, 'unit_price':  24, 'currency' : 'USD'},
          {'product_id':  'p2', 'variant_id' : 'v2', 'quantity' : 9, 'unit_price':  42, 'currency' : 'USD'},
      ],
      timestamp: '2018-04-04 23:29:04Z',
    }, {
      order_id : 'o2',
      user_id : 'u1',
      cart : [
          {'product_id' : 'p1', 'variant_id' : 'v1', 'quantity' : 1, 'unit_price' : 24, 'currency' : 'USD'},
          {'product_id' : 'p2', 'variant_id' : 'v2', 'quantity' : 9, 'unit_price' : 42, 'currency' : 'USD'},
      ],
      timestamp : '2018-04-04 23:29:04Z',
    ]
};

var hash = crypto.createHmac('sha256', apisecret).update(JSON.Stringify(data));

//add to default authentication header
axios.defaults.auth = { username: 'API-key', password: hash.digest('hex') };

axios.post(url, data);

```

Endpoint: `POST` `https://api.datacue.co/v1/batch/orders`

### Request parameters

| FieldName | Data Type | Required | Description |
| ------- | --------- | -------- | ----------- |
| `batch` | Array     | Yes      | Array of orders you are sending

### Response JSON

> The above command returns a 207 multi status response code

```json
{
    "status": [
        {
            "order_id": "o1",
            "status": "error",
            "error": "o1 already exists"
        },
        {
            "product_id": "o2",
            "status": "OK"
        }
    ]
}
```

We will send you a status for each item you sent, so you can handle and resend only items that had an error.

## Batch Create Users

```javascript--browser
"backend only event (refer to the Python, PHP or Node tab)"
```

```php
<?php

$apikey = "Your-API-Key-goes-here";
$apisecret = "Your-API-secret-goes-here";

$datacue = new \DataCue\Client($apikey, $apisecret, $options, $env);

$userDataList = [
    [
        "user_id" => "u1",
        "email" => "xyz@abc.com",
    ], [
        "user_id" => "u2",
        "email" => "abc@abc.com",
    ]
];
$res = $datacue->users->batchCreate($userDataList);

```

```python
import hashlib
import hmac
import json
import requests

url = "https://api.datacue.co/v1/batch/users"
apikey = "your-api-key-goes-here"
apisecret = "your-api-secret-goes-here"

data = {
  "batch": [
    {
      "user_id": "u1"
      "email": "u1@abc.com"
    },
    {
      "user_id": "u2"
      "email": "u2@abc.com"
    }
  ]
}

checksum = hmac.new(bytes(apisecret,'utf-8'),
  bytes(json.dumps(data)), 'utf-8'),
  hashlib.sha256)

response = requests.post(url, json=data, auth=(apikey, checksum.hexdigest())
```

```javascript--node
const axios = require('axios');
const cryto = require('crypto');

const url = 'https://api.datacue.co/v1/batch/users';
const apikey = 'your-api-key-goes-here';
const apisecret = 'your-api-secret-goes-here';

const data = {
  batch: [{
    user_id: 'u1',
    email: 'u1@abc.com'
  }, {
    user_id: 'u2',
    email: 'u2@abc.com'
  }]
};

var hash = crypto.createHmac('sha256', apisecret).update(JSON.Stringify(data));

//add to default authentication header
axios.defaults.auth = { username: 'API-key', password: hash.digest('hex') };

axios.post(url, data);

```

Endpoint: `POST` `https://api.datacue.co/v1/batch/users`

### Request parameters

| FieldName | Data Type | Required | Description |
| ------- | --------- | -------- | ----------- |
| `batch` | Array     | Yes      | Array of users you are sending

### Response JSON

> The above command returns a 207 multi status response code

```json
{
    "status": [
        {
            "user_id": "u1",
            "status": "error",
            "error": "u1 already exists"
        },
        {
            "product_id": "u2",
            "status": "OK"
        }
    ]
}
```

We will send you a status for each item you sent, so you can handle and resend only items that had an error.

## Batch Update Products

```javascript--browser
"backend only event (refer to the Python, PHP or Node tab)"
```

```php
<?php

$apikey = "Your-API-Key-goes-here";
$apisecret = "Your-API-secret-goes-here";

$datacue = new \DataCue\Client($apikey, $apisecret);

// batch update products
$productDataList = [
    [
        "product_id" => "p1",
        "variant_id" => "v1",
        "size" => "L"
    ], [
        "product_id" => "p2",
        "variant_id" => "v2",
        "size" => "L"
    ]
];
$res = $datacue->products->batchUpdate($productDataList);

```

```python
import hashlib
import hmac
import json
import requests

url = "https://api.datacue.co/v1/batch/products"
apikey = "your-api-key-goes-here"
apisecret = "your-api-secret-goes-here"

data = {
  "batch": [
    {
        "product_id": "p1",
        "variant_id": "v1",
        "size": "L"
    }, {
        "product_id": "p2",
        "variant_id": "v2",
        "size": "L"
    }
}

checksum = hmac.new(bytes(apisecret,'utf-8'), bytes(json.dumps(data)), 'utf-8'), hashlib.sha256)

response = requests.put(url, data=data, auth=(apikey, checksum.hexdigest())

```

```javascript--node
const axios = require('axios');

const url = `https://api.datacue.co/v1/batch/products`
const apikey = 'your-api-key-goes-here';
const apisecret = 'your-api-secret-goes-here';

const data = {
  batch: [{
    product_id: 'p1',
    variant_id: 'v1',
    size: 'L'
    }, {
      product_id: 'p2',
      variant_id: 'v2',
      size: 'L'
    }]
};

var hash = crypto.createHmac('sha256', apisecret).update(JSON.Stringify(data));

//add to default authentication header
axios.defaults.auth = { username: apikey, password: hash.digest('hex') };

axios.put(url, data);
```

Endpoint: `PUT` `https://api.datacue.co/v1/batch/products`

Update multiple products. Note that orders cannot be updated, only created or cancelled (delete).

### Request parameters

| FieldName   | Data Type | Required | Description |
| ------- | --------- | -------- | ----------- |
| `batch` | Array     | Yes      | Array of products you are updating |


### Response JSON

> The above command returns a 207 multi status response code

```json
{
    "status": [
        {
            "product_id": "p1",
            "status": "OK",
        },
        {
            "product_id": "p2",
            "status": "OK"
        }
    ]
}
```

We will send you a status for each item you sent, so you can handle and resend only items that had an error.

## Batch Update Users

```javascript--browser
"backend only event (refer to the Python, PHP or Node tab)"
```

```php
<?php

$apikey = "Your-API-Key-goes-here";
$apisecret = "Your-API-secret-goes-here";

$datacue = new \DataCue\Client($apikey, $apisecret);

$userDataList = [
    [
        "user_id" => "u1",
        "email" => "wxyz@abc.com",
    ], [
        "user_id" => "u2",
        "email" => "abcd@abc.com",
    ]
];
$res = $datacue->users->batchUpdate($userDataList);

```

```python
import hashlib
import hmac
import json
import requests

url = "https://api.datacue.co/v1/batch/users"
apikey = "your-api-key-goes-here"
apisecret = "your-api-secret-goes-here"

data = {
  "batch": [
    {
      "user_id":"U1",
      "first_name":"Paulo"
      "email":"u1@abc.com"
    },
    {
      "user_id":"U2",
      "last_name":"Rabani"
      "email":"u2@abc.com"
    }
  ]
}

checksum = hmac.new(bytes(apisecret,'utf-8'), bytes(json.dumps(data)), 'utf-8'), hashlib.sha256)

response = requests.put(url, data=data, auth=(apikey, checksum.hexdigest())

```

```javascript--node
const axios = require('axios');

const url = `https://api.datacue.co/v1/batch/users`
const apikey = 'your-api-key-goes-here';
const apisecret = 'your-api-secret-goes-here';

const data = {
  type: 'users',
  batch: [{
    first_name: 'Paulo',
    email: 'u1@abc.com'
  }, {
    last_name: 'Rabani',
    email: 'u2@abc.com'
  }]
};

var hash = crypto.createHmac('sha256', apisecret).update(JSON.Stringify(data));

//add to default authentication header
axios.defaults.auth = { username: apikey, password: hash.digest('hex') };

axios.put(url, data);
```

Endpoint: `PUT` `https://api.datacue.co/v1/batch/users`

Update multiple users.

### Request parameters

| FieldName   | Data Type | Required | Description |
| ------- | --------- | -------- | ----------- |
| `batch` | Array     | Yes      | Array of users you are updating |


### Response JSON

> The above command returns a 207 multi status response code

```json
{
    "status": [
        {
            "user_id": "u1",
            "status": "OK"
        },
        {
            "banner_id": "u2",
            "status": "OK"
        }
    ]
}
```

We will send you a status for each item you sent, so you can handle and resend only items that had an error.

## Batch Delete Products

```javascript--browser
"backend only event (refer to the Python, PHP or Node tab)"
```

```php
<?php

$apikey = "Your-API-Key-goes-here";
$apisecret = "Your-API-secret-goes-here";

$datacue = new \DataCue\Client($apikey, $apisecret);

// batch delete products
$productAndVariantIdList = [
    [
        "product_id" => "p1",
        "variant_id" => "v1",
    ], [
        "product_id" => "p2",
        "variant_id" => "v2",
    ]
];
$res = $datacue->products->batchDelete($productAndVariantIdList);

```

```python
import hashlib
import hmac
import json
import requests

url = "https://api.datacue.co/v1/batch/products"
apikey = "your-api-key-goes-here"
apisecret = "your-api-secret-goes-here"

data = {
  "batch": [
    {
      "product_id": "p1",
      "variant_id":"v1"
    },
    {
      "product_id": "p2",
      "variant_id":"v1"
    }
  ]
}

checksum = hmac.new(bytes(apisecret,'utf-8'), bytes(json.dumps(data)), 'utf-8'), hashlib.sha256)

response = requests.delete(url, data=data, auth=(apikey, checksum.hexdigest())
```

```javascript--node
const axios = require('axios');

const url = 'https://api.datacue.co/v1/batch/products';
const data = {
  batch: [{
    product_id: 'p1',
    variant_id: 'v1'
  }, {
    product_id: 'p2',
    variant_id: 'v1'
  }]
};

var hash = crypto.createHmac('sha256', apisecret).update(JSON.Stringify(data));

//add to default authentication header
axios.defaults.auth = { username: apikey, password: hash.digest('hex') };

axios.delete(url, data);
```

Endpoint: `DELETE` `https://api.datacue.co/v1/batch/products`

Delete multiple products within one request. Batch DELETE requests only require an id field as follows.

### Request parameters

`product_id` and `variant_id`

### Response JSON

> The above command returns a 207 multi status response code

```json
{
    "status": [
        {
            "product_id": "p1",
            "status": "error",
            "error": "Product not found"
        },
        {
            "product_id": "p2",
            "status": "OK"
        }
    ]
}
```

We will send you a status for each item you sent, so you can handle and resend only items that had an error.

## Batch Delete Users

```javascript--browser
"backend only event (refer to the Python, PHP or Node tab)"
```

```php
<?php

$apikey = "Your-API-Key-goes-here";
$apisecret = "Your-API-secret-goes-here";

$datacue = new \DataCue\Client($apikey, $apisecret);

// batch delete users
$userIdList = ['u1', 'u2'];
$res = $datacue->users->batchDelete($userIdList);

```

```python
import hashlib
import hmac
import json
import requests

url = "https://api.datacue.co/v1/batch/users"
apikey = "your-api-key-goes-here"
apisecret = "your-api-secret-goes-here"

data = {
  "batch": [
    {
      "user_id": "u1"
    },
    {
      "user_id": "u2"
    },
    {
      "user_id": "u3"
    }
  ]
}

checksum = hmac.new(bytes(apisecret,'utf-8'), bytes(json.dumps(data)), 'utf-8'), hashlib.sha256)

response = requests.delete(url, data=data, auth=(apikey, checksum.hexdigest())
```

```javascript--node
const axios = require('axios');

const url = 'https://api.datacue.co/v1/batch/users';

const data = {
  batch: [{
    user_id: 'u1'
  }, {
    user_id: 'u2'
  }, {
    user_id: 'u3'
  }]
};

var hash = crypto.createHmac('sha256', apisecret).update(JSON.Stringify(data));

//add to default authentication header
axios.defaults.auth = { username: apikey, password: hash.digest('hex') };

axios.delete(url, data);
```

Endpoint: `DELETE` `https://api.datacue.co/v1/batch/users`

Delete multiple users within one request. Batch DELETE requests only require an id field as follows.

### Request parameters

`user_id`

### Response JSON

> The above command returns a 207 multi status response code

```json
{
    "status": [
        {
            "user_id": "u1",
            "status": "OK"
        },
        {
            "user_id": "u2",
            "status": "OK"
        }
    ]
}
```

We will send you a status for each item you sent, so you can handle and resend only items that had an error.

## Batch Delete Orders

```javascript--browser
"backend only event (refer to the Python, PHP or Node tab)"
```

```php
<?php

$apikey = "Your-API-Key-goes-here";
$apisecret = "Your-API-secret-goes-here";

$datacue = new \DataCue\Client($apikey, $apisecret);

$orderIdList = ['o1', 'o2'];
$res = $datacue->orders->batchCancel($orderIdList);

```

```python
import hashlib
import hmac
import json
import requests

url = "https://api.datacue.co/v1/batch/orders"
apikey = "your-api-key-goes-here"
apisecret = "your-api-secret-goes-here"

data = {
  "batch": [
    {
      "order_id": "o1"
    },
    {
      "order_id": "o2"
    }
  ]
}

checksum = hmac.new(bytes(apisecret,'utf-8'), bytes(json.dumps(data)), 'utf-8'), hashlib.sha256)

response = requests.delete(url, data=data, auth=(apikey, checksum.hexdigest())
```

```javascript--node
const axios = require('axios');

const url = 'https://api.datacue.co/v1/batch/orders';

const data = {
  batch: [{
    order_id: 'o1'
  }, {
    order_id: 'o2'
  }]
};

var hash = crypto.createHmac('sha256', apisecret).update(JSON.Stringify(data));

//add to default authentication header
axios.defaults.auth = { username: apikey, password: hash.digest('hex') };

axios.delete(url, data);
```

Endpoint: `DELETE` `https://api.datacue.co/v1/batch/orders`

Delete multiple orders within one request. Batch DELETE requests only require an id field as follows.

### Request parameters

`order_id`

### Response JSON

> The above command returns a 207 multi status response code

```json
{
    "status": [
        {
            "order_id": "o1",
            "status": "OK"
        },
        {
            "order_id": "o2",
            "status": "OK"
        }
    ]
}
```

We will send you a status for each item you sent, so you can handle and resend only items that had an error.
