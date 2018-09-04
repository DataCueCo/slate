---
title: API Reference

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

Welcome to the DataCue API. This API documentation is to help you setup your e-commerce store to apply real time personalization to your website.

We have language bindings in Javascript, PHP, and Python. You can view code examples in the dark area to the right, and you can switch the programming language of the examples with the tabs in the top right. On a mobile device, switch the language using the hamburger menu on the rop left.

## API URL

The API is located at `https://api.datacue.co`.

## Headers

### Authentication

> Make sure to replace `API-key` with your API key and `API-secret` with your API secret, and only use the secret with non-event endpoints.

```php
<?php
$updatedProduct->name = "Blue Jeans";
$updatedProduct->price = 30;

$apikey = "Your-API-Key-goes-here";
$apisecret = "Your-API-secret-goes-here";
$payload = json_encode($updatedProduct);
$url = "https://api.datacue.co/v1/products/:product_id/:variant_id";

// now encode it to base64
$checksum = hash_hmac('sha256', $payload, $apisecret, true);

$encode = base64_encode("$apikey:$checksum");
$auth = "Basic $encode";

$curl = curl_init($url);
curl_setopt($curl, CURLOPT_HEADER, false);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_HTTPHEADER, array(
  "Content-type" => "application/json",
  "Authorization" => $auth
));
curl_setopt($curl, CURLOPT_POST, true);
curl_setopt($curl, CURLOPT_POSTFIELDS, $payload);

$json_response = curl_exec($curl);

?>

```

```python
import hashlib
import hmac
import base64
import json
import requests

apiurl = "https://api.datacue.co"
apikey = "your-api-key-goes-here"
apisecret = "your-api-secret-goes-here"

updatedProduct = {
  "name" : "Blue Jeans",
  "price" : 30
}

payload = json.dumps(updatedProduct)

checksum = hmac.new(bytes(apisecret,'utf-8'), bytes(payload), 'utf-8'), hashlib.sha256)
authToken = bytes(apikey + ":" + checksum.hexdigest(),'utf-8')
auth = "Basic {}".format(base64.b64encode(auth).decode('ascii'))

# Add auth to your auth header
headers = {
"Content-type": "application/json",
"Authorization": auth
}
response = requests.post(apiurl + "/v1/products/:product_id/:variant_id", data=payload, headers=headers)
```

```javascript--node
const axios = require('axios');
const cryto = require('crypto');

const apikey = "your-api-key-goes-here"
const apisecret = "your-api-secret-goes-here"

const updatedProduct = {
  "name" : "Blue Jeans",
  "price" : 30
}

var hash = crypto.createHmac('sha256', apisecret).update(JSON.Stringify(updatedProduct));

//add to default authentication header
axios.defaults.auth = { username: 'API-key', password: hash.digest('hex') };```

```javascript--browser
window.datacue.init('API-key');
```

> Sample Headers

```
"Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
"Content-Type": "application/json"
```

You can find your API key and API secret in your [DataCue Dashboard](https://app.datacue.co "Dashboard").

The browser events endpoint only require an API key as it called from the browser. All other endpoints require both the API key and the payload to be signed with your API secret. NEVER send your api secret with the message. 
We use HTTP Basic Authentication, where the username is your apikey and the password is the hmac sha256 checksum of your payload. Refer to the code samples to see how to do this in your language of choice.

#### Browser Events (only API key):

The client library manages the headers for you, using the API key you pass to the `init()` method.
If your API key is `abc123`, then Base64 encode "abc123:", no password after the colon, and the final result will be "YWJjMTIzOg==".

Your authorization header should look like `Authorization: Basic YWJjMTIzOg==`.

#### Backend End points (API Key and API Secret):
Let's say your API key is `abc123` and your API secret is `secret123`.

- Use an HMAC library for your language of choice to hash your JSON payload using your API secret as the key. You should see an output like: `4643978965ffcec6e6d73b36a39ae43ceb15f7ef8131b8307862ebc560e7f988`
- Set your HTTP library to use Basic Authentication, specify your API key `abc123` as the username and the result of the above hash operation as your password. The hash above is just an example and will not work.

Refer to the code samples above which shows you how to implement this in multiple popular languages.

### Content-Type

You must set a content-type header to "application/json".
`Content-Type: application/json`

# Browser Events

Endpoint: `POST` `https://api.datacue.co/v1/events`

## Authorization

All events are meant to be sent from your users' browsers using our embedded script. This endpoint requires **only** your API Key.

## Format

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

### user

| Field          | Data Type   | Required               | Description |
| -------------- | ----------- | ---------------------- | ----------- |
| `user_id`      | String      | Yes (if logged in)     | The unique user id if the user has logged in
| `anonymous_id` | String      | Yes (if not logged in) | An automatically generated visitor id if the user has not logged in.
| `profile`      | JSON Object | No                     | Any user segmentation data you know about the user, see the table below for details.

<aside class="notice">
  If you send us both a <code>user_id</code> and <code>anonymous_id</code> we will record the <code>user_id</code>.
</aside>

### user.profile

| Field      | Data Type | Required | Description |
| ---------- | --------- | -------- | ----------- |
| `sex`      | String    | No       | Sex of the user
| `segment`  | String    | No       | Custom segment name that you store e.g. Gold class / Member
| `location` | String    | No       | Location of the user as a commune, city, region or country

The above are the most common types of profile segments, since it's a JSON object you can specify any other fields you wish to use for personalization.

### event

Field descriptions differ per event type. Please refer to the event descriptions below to know what fields are required.

### context (optional)

We use incoming HTTP headers to fill in this object, therefore this object is optional. You can specify context if you are sending historical data, or have any other special requirements that require overriding the default headers.

Refer to the example json on the right to view the format.

```json
  "context": {
    "ip": "12.34.56.78",
    "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  }
```

| Field        | Data Type | Required | Description |
| ------------ | --------- | -------- | ----------- |
| `ip`         | String    | No       | IP address
| `user_agent` | String    | No       | User agent string of the browser

### timestamp (optional)

Only required if you're sending us historical events, if not, we log the event at the time we received it.

Refer to the example json on the right to view the format.

```json
  "timestamp": "2018-01-23T00:30:08.276Z"
```

| Field       | Data Type     | Required | Description |
| ----------- | ------------- | -------- | ----------- |
| `timestamp` | ISO-8601 Date | No       | The current time in UTC for when the event happened. E.g. `"2017-11-01T00:29:03.123Z"`


## Home Page View

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

| Field     | Data Type | Required | Description |
| --------- | --------- | -------- | ----------- |
| `type`    | String    | Yes      | Set to `'pageview'`
| `subtype` | String    | Yes      | Set to `'home'`

### Response JSON

| Field                  | Data Type | Description |
| ---------------------- | --------- | ----------- |
| `main_banners`         | Array     | An array of banner objects recommended for the current user
| `sub_banners`          | Array     | An array of sub banner objects recommended for the current user
| `related_product_skus` | Array     | An array of product objects recommended for the current user
| `recent_product_skus`  | Array     | A live list of the last products the current user has viewed

## Product Page View

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

| Field        | Data Type | Required | Description |
| ------------ | --------- | -------- | ----------- |
| `type`       | String    | Yes      | Set to `'pageview'`
| `subtype`    | String    | Yes      | Set to `'related'`
| `product_id` | String    | Yes      | Set to product id being viewed
| `variant_id` | String    | No       | Set to product's variant id (if applicable)

### Response JSON

| Field                  | Data Type | Description |
| ---------------------- | --------- | ----------- |
| `similar_product_skus` | Array     | An array of product objects with similar characteristics to the current product
| `related_product_skus` | Array     | An array of product objects that are frequently bought with the current product
| `recent_product_skus`  | Array     | A live list of the last products the current user has viewed

## Category Page View

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

| Field           | Data Type | Required | Description |
| --------------- | --------- | -------- | ----------- |
| `type`          | String    | Yes      | Set to `'pageview'`
| `subtype`       | String    | Yes      | Set to `'category'`
| `category_name` | String    | Yes      | Set to the name of the category being viewed

## Shopping Cart Updated / Viewed

```javascript--browser
// assign user_id and user.profile if you haven't yet
window.datacue.identify('019mr8mf4r', {
  sex: 'female',
  location: 'Santiago',
  segment: 'platinum'
});

// track the event
window.datacue.track({
  type: 'viewcart',
  cart: [{
    product_id: 'p1',
    variant_id: 'v1'
  },{
    product_id: 'p2',
    variant_id: 'v1'
  },{
    product_id: 'p3',
    variant_id: 'v1'
  }]
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

Record activity on a users shopping cart, typically when the cart is viewed, or an item is added or removed.

### Request parameters

| Field  | Data Type | Required | Description |
| ------ | --------- | -------- | ----------- |
| `type` | String    | Yes      | Set to `'viewcart'`
| `cart` | Array     | Yes      | Specify an array of `product_id`s and optionally `variant_id`s

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

| Field  | Data Type | Required | Description |
| ------ | --------- | -------- | ----------- |
| `type` | String    | Yes      | Set to `'search'`
| `term` | String    | Yes      | Set to the user's search term

### Response JSON

| Field                 | Data Type | Description |
| --------------------- | --------- | ----------- |
| `recent_product_skus` | Array     | A live list of the last products the current user has viewed

## Add Product to Wishlist

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

| Field        | Data Type | Required | Description |
| ------------ | --------- | -------- | ----------- |
| `type`       | String    | Yes      | Set to `'wishlist'`
| `subtype`    | String    | Yes      | Set to `'add'`
| `product_id` | String    | Yes      | Set to product id being added
| `variant_id` | String    | No       | Set to product's variant id (if applicable)

## Remove Product from Wishlist

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

| Field        | Data Type | Required | Description |
| ------------ | --------- | -------- | ----------- |
| `type`       | String    | Yes      | Set to `'wishlist'`
| `subtype`    | String    | Yes      | Set to `'remove'`
| `product_id` | String    | Yes      | Set to product id being removed
| `variant_id` | String    | No       | Set to product's variant id (if applicable)

## Banner Click

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

| Field       | Data Type | Required | Description |
| ----------- | --------- | -------- | ----------- |
| `type`      | String    | Yes      | Set to `'click'`
| `subtype`   | String    | Yes      | Set to `'banner'`
| `banner_id` | String    | Yes      | Set to the id of the clicked banner

## Product Click

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

| Field        | Data Type | Required | Description |
| ------------ | --------- | -------- | ----------- |
| `type`       | String    | Yes      | Set to `'click'`
| `subtype`    | String    | Yes      | Set to `'related'`, `'similar'` or `'recent'`
| `product_id` | String    | Yes      | Set to the id of the clicked product

## Start Order (Check Out Started)

```javascript--browser
// assign user_id and user.profile if you haven't yet
window.datacue.identify('019mr8mf4r', {
  sex: 'female',
  location: 'Santiago',
  segment: 'platinum'
});

// track the event
window.datacue.track({
  type: 'order',
  subtype: 'started',
  order_id: 'o1',
  cart: [{
    product_id: 'p1',
    variant: 'v1',
    quantity: 1,
    price: 24,
    currency: 'USD'
  }]
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

| Field      | Data Type | Required | Description |
| ---------- | --------- | -------- | ----------- |
| `type`     | String    | Yes      | Set to `'order'`
| `subtype`  | String    | Yes      | Set to `'started'`
| `order_id` | String    | No       | Set to the id of the order (if available)
| `cart`     | Array     | Yes      | Cart contents as an array of product, variant, unit price, quantity and currency

## Complete Order

```javascript--browser
// assign user_id and user.profile if you haven't yet
window.datacue.identify('019mr8mf4r', {
  sex: 'female',
  location: 'Santiago',
  segment: 'platinum'
});

// track the event
window.datacue.track({
  type: 'order',
  subtype: 'completed',
  order_id: 'o1',
  payment_method: '',
  cart: [{
    product_id: 'p1',
    variant_id: 'v1',
    quantity: 1,
    unit_price: 24,
    currency: 'USD'
  }]
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

Record the moment the order (or checkout) is completed.

### Request parameters

| Field            | Data Type | Required | Description |
| ---------------- | --------- | -------- | ----------- |
| `type`           | String    | Yes      | Set to `'order'`
| `subtype`        | String    | Yes      | Set to `'completed'`
| `order_id`       | String    | Yes      | Set to the id of the order
| `cart`           | Array     | Yes      | Cart contents as an array of product, variant, unit price, quantity and currency
| `payment_method` | String    | No       | Specify the payment method used (for analytics)

## Cancel Order

```javascript--browser
// assign user_id and user.profile if you haven't yet
window.datacue.identify('019mr8mf4r', {
  sex: 'female',
  location: 'Santiago',
  segment: 'platinum'
});

// track the event
window.datacue.track({
  type: 'order',
  subtype: 'cancelled',
  order_id: 'o1'
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

Record the moment the order (or checkout) is cancelled.

### Request parameters

| Field      | Data Type | Required | Description |
| ---------- | --------- | -------- | ----------- |
| `type`     | String    | Yes      | Set to `'order'`
| `subtype`  | String    | Yes      | Set to `'cancelled'`
| `order_id` | String    | Yes      | Set to the id of the order

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

Record logins by a user on your website, if the user login is cached, you do not need to fire this event when the user returns.

### Request parameters

| Field  | Data Type | Required | Description |
| ------ | --------- | -------- | ----------- |
| `type` | String    | Yes      | Set to `'login'`

# Products

## Create Product

```javascript--browser
"backend only event (refer to the Python, PHP or Node tab)"
```

```php
<?php

$url = "https://api.datacue.co/v1/products";
$data = array(
  "product_id" => "p1",
  "variant_id" => "v1",
  "category_1" => "men",
  "category_2" => "jeans",
  "category_3" => "skinny",
  "category_4" => "c4",
  "category_extra" => array(
    "category_5" => "c5"
  ),
  "name" => "cool jeans",
  "brand" => "zara",
  "description" => "very fashionable jeans",
  "color" => "blue"
  "size" => "M",
  "price" => 25000,
  "stock" => 5,
  "extra" => array(
    "extra_feature" => "details"
  ),
  "photo_url" => "https://s3.amazon.com/image.png",
  "link" => "/product/p1",
  "owner_id" => "user_id_3"
);

$content = json_encode($data);

$curl = curl_init($url);
curl_setopt($curl, CURLOPT_HEADER, false);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_HTTPHEADER, array(
  "Content-type" => "application/json",
  "Authorization" => "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
));
curl_setopt($curl, CURLOPT_POST, true);
curl_setopt($curl, CURLOPT_POSTFIELDS, $content);

$json_response = curl_exec($curl);
```

```python
import requests

url = "https://api.datacue.co/v1/products"
headers = {
  "Content-type": "application/json",
  "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
}
data = {
  "product_id": "p1",
  "variant_id": "v1",
  "category_1": "men",
  "category_2": "jeans",
  "category_3": "skinny",
  "category_4": "c4",
  "category_extra": {
    "category_5": "c5"
  },
  "name": "cool jeans",
  "brand": "zara",
  "description": "very fashionable jeans",
  "color": "blue",
  "size": "M",
  "price": 25000,
  "stock": 5,
  "extra": {
    "extra_feature": "details"
  },
  "photo_url": "https://s3.amazon.com/image.png",
  "link": "/product/p1",
  "owner_id": "user_id_3"
}

response = requests.post(url, data=data, headers=headers)
```

```javascript--node
const axios = require('axios');

axios.defaults.baseURL = 'https://api.datacue.co/v1';
axios.defaults.auth = { username: 'API-key', password: 'API-secret' };

const data = {
  product_id: 'p1',
  variant_id: 'v1',
  category_1: 'men',
  category_2: 'jeans',
  category_3: 'skinny',
  category_4: 'c4',
  category_extra: {
    category_5: 'c5'
  },
  name: 'cool jeans',
  brand: 'zara',
  description: 'very fashionable jeans',
  color: 'blue',
  size: 'M',
  price: 25000,
  stock: 5,
  extra: {
    extra_feature: 'details'
  },
  photo_url: 'https://s3.amazon.com/image.png',
  link: '/product/p1',
  owner_id: 'user_id_3'
};

axios.post('/products', data);
```

> The above command returns a 201 response code

Endpoint: `POST` `https://api.datacue.co/v1/products`

Whenever a new product is created, send this request from your backend.

### Request parameters

| Field            | Data Type   | Required | Description |
| ---------------- | ----------- | -------- | ----------- |
| `product_id`     | String      | Yes      | The product id or SKU number
| `variant_id`     | String      | Yes      | A unique variant id within the product id, if you only use product SKUs set this to a constant such as 'no-variants'
| `category_1`     | String      | Yes      | Top category level of product e.g. 'Men' , 'Women' or 'Children''.
| `category_2`     | String      | No       | Second category level of product e.g. 'Shoes' or 'Dresses'
| `category_3`     | String      | No       | Third category level of product e.g. 'Sports' or 'Sandals'
| `category_4`     | String      | No       | Fourth category level of product e.g. 'Running shoes'
| `category_extra` | JSON Object | No       | Any other categories can be stored here as an object, e.g. `"category_extra": { "category_5": "value" }` and so on.
| `name`           | String      | Yes      | Name or Title of the product
| `brand`          | String      | No       | Brand name of the product
| `description`    | String      | No       | Long text description of the product
| `color`          | String      | No       | Color of the product
| `size`           | String      | No       | Size of the product
| `price`          | Decimal     | Yes      | Price of the product up to two decimal places
| `available`      | Boolean     | No       | Is the product available for Sale (Default true)
| `stock`          | Integer     | Yes      | Number of product in stock
| `extra`          | JSON Object | No       | Any other fields you want to store about the product that you want to display on site e.g. discounts or promotions.
| `photo_url`      | String      | Yes      | URL of the photo, you can use relative URLs as this is purely for your front-end to request the image
| `link`           | String      | Yes      | URL of product page for this product e.g. /products/p1
| `owner_id`       | String      | No       | If you're running a marketplace, store the product's owner or seller's user ID here.

## Update Product

```javascript--browser
"backend only event (refer to the Python, PHP or Node tab)"
```

```php
<?php

$url = "https://api.datacue.co/v1/products/:product_id/:variant_id";
$data = array(
  "category_1" => "men",
  "category_2" => "jeans",
  "category_3" => "skinny",
  "stock" => 6,
  "available" => false
);

$content = json_encode($data);

$curl = curl_init($url);
curl_setopt($curl, CURLOPT_HEADER, false);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_HTTPHEADER, array(
  "Content-type" => "application/json",
  "Authorization" => "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
));
curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "PUT");
curl_setopt($curl, CURLOPT_POSTFIELDS, $content);

$json_response = curl_exec($curl);
```

```python
import requests

url = "https://api.datacue.co/v1/products/:product_id/:variant_id"
headers = {
  "Content-type": "application/json",
  "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
}
data = {
  "category_1": "men",
  "category_2": "jeans",
  "category_3": "skinny",
  "stock": 6,
  "available": False
}

response = requests.put(url, data=data, headers=headers)
```

```javascript--node
const axios = require('axios');

axios.defaults.baseURL = 'https://api.datacue.co/v1';
axios.defaults.auth = { username: 'API-key', password: 'API-secret' };

const data = {
  category_1: 'men',
  category_2: 'jeans',
  category_3: 'skinny'
  stock: 6,
  available: false
};

axios.put(`/products/${productId}/${variantId}`, data);
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

$url = "https://api.datacue.co/v1/products/:product_id/:variant_id";

$curl = curl_init($url);
curl_setopt($curl, CURLOPT_HEADER, false);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_HTTPHEADER, array(
  "Content-type" => "application/json",
  "Authorization" => "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
));
curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "DELETE");

$json_response = curl_exec($curl);
```

```python
import requests

url = "https://api.datacue.co/v1/products/:product_id/:variant_id"
headers = {
  "Content-type": "application/json",
  "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
}

response = requests.delete(url, headers=headers)
```

```javascript--node
const axios = require('axios');

axios.defaults.baseURL = 'https://api.datacue.co/v1';
axios.defaults.auth = { username: 'API-key', password: 'API-secret' };

axios.delete(`/products/${productId}/${variantId}`);
```

> The above command returns a 204 response code

Delete a product on your system.

### Delete a variant

Endpoint: `DELETE` `https://api.datacue.co/v1/products/<product_id>/<variant_id>`

### Delete a product and all associated variants

Endpoint: `DELETE` `https://api.datacue.co/v1/products/<product_id>`

# Banners

<aside class="notice">
  We recommend that you use your DataCue dashboard to upload and manage your banners. However, if you want DataCue to use your existing banner management solution, you can use these endpoints to do so.
</aside>

## Create Banner

```javascript--browser
"backend only event (refer to the Python, PHP or Node tab)"
```

```php
<?php

$url = "https://api.datacue.co/v1/banners";
$data = array(
  "banner_id" => "b1",
  "type" => "sub",
  "name" => "friendly name for b1",
  "category_1" => "women",
  "category_2" => "summer",
  "category_3" => "dresses",
  "category_4" => "casual",
  "photo_url" => "/photos/b1.jpg",
  "photos" => array(
    "mobile" => "http://s3.amazon.com/photoMobile.png",
    "desktop" => "http://s3.amazon.com/photoDesktop.png"
  ),
  "link" => "path/to/anything",
  "extra" => array(
    "meta" => "any field you want to store"
  )
);

$content = json_encode($data);

$curl = curl_init($url);
curl_setopt($curl, CURLOPT_HEADER, false);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_HTTPHEADER, array(
  "Content-type" => "application/json",
  "Authorization" => "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
));
curl_setopt($curl, CURLOPT_POST, true);
curl_setopt($curl, CURLOPT_POSTFIELDS, $content);

$json_response = curl_exec($curl);
```

```python
import requests

url = "https://api.datacue.co/v1/banners"
headers = {
  "Content-type": "application/json",
  "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
}
data = {
  "banner_id": "b1",
  "type": "sub",
  "name": "friendly name for b1",
  "category_1": "women",
  "category_2": "summer",
  "category_3": "dresses",
  "category_4": "casual",
  "photo_url": "/photos/b1.jpg",
  "other_photos": {
    "mobile": "http://s3.amazon.com/photoMobile.png",
    "desktop": "http://s3.amazon.com/photoDesktop.png"
  },
  "link": "path/to/anything",
  "extra": {
    "meta": "any field you want to store"
  }
}

response = requests.post(url, data=data, headers=headers)
```

```javascript--node
const axios = require('axios');

axios.defaults.baseURL = 'https://api.datacue.co/v1';
axios.defaults.auth = { username: 'API-key', password: 'API-secret' };

const data = {
  banner_id: 'b1',
  type: 'sub',
  name: 'friendly name for b1',
  category_1: 'women',
  category_2: 'summer',
  category_3: 'dresses',
  category_4: 'casual',
  photo_url: '/photos/b1.jpg',
  other_photos: {
    mobile: 'http://s3.amazon.com/photoMobile.png',
    desktop: 'http://s3.amazon.com/photoDesktop.png'
  },
  link: 'path/to/anything',
  extra: {
    meta: 'any field you want to store'
  }
};

axios.post('/banners', data);
```

> The above command returns a 201 response code

Endpoint: `POST` `https://api.datacue.co/v1/banners`

When you create a new banner on your system.

### Request parameters

| Field        | Data Type   | Required | Description |
| ------------ | ----------- | -------- | ----------- |
| `banner_id`  | String      | Yes      | A unique id for your banner
| `type`       | String      | Yes      | The type of banner. Set to `'main'` for main banner or `'sub'` for sub banner
| `name`       | String      | No       | Friendly name for the banner
| `category_1` | String      | Yes      | The top category level this banner belongs to. In a fashion store, this could be 'Men' , 'Women' or 'Children''
| `category_2` | String      | No       | The second category level this banner belongs to. In a fashion store, this could be 'Shoes or 'Dresses'
| `category_3` | String      | No       | The third category level this banner belongs to. In a fashion store, this could be 'Sports' or 'Sandals'
| `category_4` | String      | No       | The fourth category level this banner belongs to. In a fashion store, this could be 'Running shoes'
| `photo_url`  | String      | Yes      | URL of the banner image, you can use relative URLs as this is purely for your front-end to request the image
| `link`       | String      | Yes      | Which page to take the user to when they click on the banner on your website. Typically a collection or catalog page for the banner's associated category.
| `extra`      | JSON Object | No       | Any other information you would like to use for special processing in the browser.

## Update Banner

```javascript--browser
"backend only event (refer to the Python, PHP or Node tab)"
```

```php
<?php

$url = "https://api.datacue.co/v1/banners/:banner_id";
$data = array(
  "link" => "/new-link"
);

$content = json_encode($data);

$curl = curl_init($url);
curl_setopt($curl, CURLOPT_HEADER, false);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_HTTPHEADER, array(
  "Content-type" => "application/json",
  "Authorization" => "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
));
curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "PUT");
curl_setopt($curl, CURLOPT_POSTFIELDS, $content);

$json_response = curl_exec($curl);
```

```python
import requests

url = "https://api.datacue.co/v1/banners/:banner_id"
headers = {
  "Content-type": "application/json",
  "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
}
data = {
  "link": "/new-link"
}

response = requests.put(url, data=data, headers=headers)
```

```javascript--node
const axios = require('axios');

axios.defaults.baseURL = 'https://api.datacue.co/v1';
axios.defaults.auth = { username: 'API-key', password: 'API-secret' };

const data = {
  "link": "/new-link"
};

axios.put(`/banners/${bannerId}`, data);
```

> The above command returns a 204 response code

Endpoint: `PUT` `https://api.datacue.co/v1/banners/<banner_id>`

When you update your banner in any way like changing the banner image, link or assigned categories on your system. Does not apply if you're using DataCue to manage your banners.

Only send fields to be updated

### Request parameters

Same as for [Create Banner](#create-banner), except `banner_id`.

## Delete Banner

```javascript--browser
"backend only event (refer to the Python, PHP or Node tab)"
```

```php
<?php

$url = "https://api.datacue.co/v1/banners/:banner_id";

$curl = curl_init($url);
curl_setopt($curl, CURLOPT_HEADER, false);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_HTTPHEADER, array(
  "Content-type" => "application/json",
  "Authorization" => "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
));
curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "DELETE");

$json_response = curl_exec($curl);
```

```python
import requests

url = "https://api.datacue.co/v1/banners/:banner_id"
headers = {
  "Content-type": "application/json",
  "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
}

response = requests.delete(url, headers=headers)
```

```javascript--node
const axios = require('axios');

axios.defaults.baseURL = 'https://api.datacue.co/v1';
axios.defaults.auth = { username: 'API-key', password: 'API-secret' };

axios.delete(`/banners/${bannerId}`);
```

> The above command returns a 204 response code

Endpoint: `DELETE` `https://api.datacue.co/v1/banners/<banner_id>`

When you delete a banner on your system. Does not apply if you're using DataCue to manage your banners.

# Users

## Create User

```javascript--browser
"backend only event (refer to the Python, PHP or Node tab)"
```

```php
<?php

$url = "https://api.datacue.co/v1/users";
$data = array(
  "user_id" => "u1",
  "anonymous_ids" => "v1",
  "email" => "xyz@abc.com",
  "title" => "Mr",
  "first_name" => "John",
  "last_name" => "Smith",
  "profile" => array(
    "location" => "santiago",
    "sex" => "male",
    "segment" => "platinum"
  ),
  "email_subscriber" => true,
  "cart" => array(
    array("product_id" => "p1", "variant_id" => "v1"),
    array("product_id" => "p2", "variant_id" => "v1")
  ),
  "timestamp" => "2018-04-04T23:29:04-03:00"
);

$content = json_encode($data);

$curl = curl_init($url);
curl_setopt($curl, CURLOPT_HEADER, false);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_HTTPHEADER, array(
  "Content-type" => "application/json",
  "Authorization" => "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
));
curl_setopt($curl, CURLOPT_POST, true);
curl_setopt($curl, CURLOPT_POSTFIELDS, $content);

$json_response = curl_exec($curl);
```

```python
import requests

url = "https://api.datacue.co/v1/users"
headers = {
  "Content-type": "application/json",
  "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
}
data = {
  "user_id": "u1",
  "anonymous_ids": "v1",
  "email": "xyz@abc.com",
  "title": "Mr",
  "first_name": "John",
  "last_name": "Smith",
  "profile": {
    "location": "santiago",
    "sex": "male",
    "segment": "platinum"
  },
  "email_subscriber": True,
  "cart": [
    {
      "product_id": "p1",
      "variant_id": "v1"
    },
    {
      "product_id": "p2",
      "variant_id": "v1"
    }
  ],
  "timestamp": "2018-04-04T23:29:04-03:00"
}

response = requests.post(url, data=data, headers=headers)
```

```javascript--node
const axios = require('axios');

axios.defaults.baseURL = 'https://api.datacue.co/v1';
axios.defaults.auth = { username: 'API-key', password: 'API-secret' };

const data = {
  user_id: 'u1',
  anonymous_ids: 'v1',
  email: 'xyz@abc.com',
  title: 'Mr',
  first_name: 'Noob',
  last_name: 'Saibot',
  profile: {
    location: 'santiago',
    sex: 'male',
    segment: 'platinum'
  },
  email_subscriber: true,
  cart: [{
    product_id: 'p1',
    variant_id: 'v1'
  }, {
    product_id: 'p2',
    variant_id: 'v1'
  }],
  timestamp: '2018-04-04T23:29:04-03:00'
};

axios.post('/users', data);
```

> The above command returns a 201 response code

Endpoint: `POST` `https://api.datacue.co/v1/users`

When a new user has successfully signed up / registered on your system.

### Request parameters

| Field              | Data Type     | Required                      | Description |
| ------------------ | ------------- | ----------------------------- | ----------- |
| `user_id`          | String        | Yes                           | The unique user id assigned
| `anonymous_id`     | String        | No                            | Anonymous ID that was previously associated with this user prior to user sign up
| `email`            | String        | Yes, if using email marketing | User's email address
| `title`            | String        | No                            | Salutation e.g. Mr., Ms., Dr.
| `first_name`       | String        | Yes                           | User's first name, if you store all the names in one field assign the name to this field
| `last_name`        | String        | No                            | User's last name
| `profile`          | JSON Object   | No                            | User's profile. See table below for field description
| `email_subscriber` | Boolean       | No                            | Has this user consented to receive marketing email?
| `cart`             | Array         | No                            | An array of product ids and variant ids representing the current products in the users shopping cart.
| `timestamp`        | ISO-8601 Date | No                            | User creation date/time in UTC timezone

### profile

| Field      | Data Type | Required | Description |
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

$url = "https://api.datacue.co/v1/users/:user_id";
$data = array(
  "profile" => array(
    "location" => "singapore"
  )
);

$content = json_encode($data);

$curl = curl_init($url);
curl_setopt($curl, CURLOPT_HEADER, false);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_HTTPHEADER, array(
  "Content-type" => "application/json",
  "Authorization" => "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
));
curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "PUT");
curl_setopt($curl, CURLOPT_POSTFIELDS, $content);

$json_response = curl_exec($curl);
```

```python
import requests

url = "https://api.datacue.co/v1/users/:user_id"
headers = {
  "Content-type": "application/json",
  "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
}
data = {
  "profile": {
    "location": "singapore"
  }
}

response = requests.put(url, data=data, headers=headers)
```

```javascript--node
const axios = require('axios');

axios.defaults.baseURL = 'https://api.datacue.co/v1';
axios.defaults.auth = { username: 'API-key', password: 'API-secret' };

const data = {
  profile: {
    location: 'singapore'
  }
};

axios.put(`/users/${userId}`, data);
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

$url = "https://api.datacue.co/v1/users/:user_id";

$curl = curl_init($url);
curl_setopt($curl, CURLOPT_HEADER, false);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_HTTPHEADER, array(
  "Content-type" => "application/json",
  "Authorization" => "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
));
curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "DELETE");

$json_response = curl_exec($curl);
```

```python
import requests

url = "https://api.datacue.co/v1/users/:user_id"
headers = {
  "Content-type": "application/json",
  "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
}

response = requests.delete(url, headers=headers)
```

```javascript--node
const axios = require('axios');

axios.defaults.baseURL = 'https://api.datacue.co/v1';
axios.defaults.auth = { username: 'API-key', password: 'API-secret' };

axios.delete(`/users/${userId}`);
```

> The above command returns a 204 response code

Endpoint: `DELETE` `https://api.datacue.co/v1/users/<user_id>`

When a user account is deleted from your system.

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

> To submit multiple, just set type to "products" and insert an array of product requests in the batch field like so:

```json
{
  "type": "products",
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

Tell us what you're sending via the `type` and insert an array of your requests in the `batch` field.

## Batch Create Banners / Orders / Products / Users

```javascript--browser
"backend only event (refer to the Python, PHP or Node tab)"
```

```php
<?php

$url = "https://api.datacue.co/v1/batch";
$data = array(
  "type" => "users",
  "batch" => array(
    array("user_id" => "u1","email" => "u1@abc.com"),
    array("user_id" => "u2","email" => "u2@abc.com"),
    array("user_id" => "u3","email" => "u3@abc.com"),
  )
);

$content = json_encode($data);

$curl = curl_init($url);
curl_setopt($curl, CURLOPT_HEADER, false);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_HTTPHEADER, array(
  "Content-type" => "application/json",
  "Authorization" => "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
));
curl_setopt($curl, CURLOPT_POST, true);
curl_setopt($curl, CURLOPT_POSTFIELDS, $content);

$json_response = curl_exec($curl);
```

```python
import requests

url = "https://api.datacue.co/v1/batch"
headers = {
  "Content-type": "application/json",
  "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
}
data = {
  "type": "users",
  "batch": [
    {
      "user_id": "u1"
      "email": "u1@abc.com"
    },
    {
      "user_id": "u2"
      "email": "u2@abc.com"
    },
    {
      "user_id": "u3"
      "email": "u3@abc.com"
    }
  ]
}

response = requests.post(url, data=data, headers=headers)
```

```javascript--node
const axios = require('axios');

axios.defaults.baseURL = 'https://api.datacue.co/v1';
axios.defaults.auth = { username: 'API-key', password: 'API-secret' };

const data = {
  type: 'users',
  batch: [{
    user_id: 'u1',
    email: 'u1@abc.com'
  }, {
    user_id: 'u2',
    email: 'u2@abc.com'
  }, {
    user_id: 'u3',
    email: 'u3@abc.com'
  }]
};

axios.post('/batch', data);
```

Endpoint: `POST` `https://api.datacue.co/v1/batch`

### Request parameters

| Field   | Data Type | Required | Description |
| ------- | --------- | -------- | ----------- |
| `type`  | String    | Yes      | Set to `'products'`, `'orders'` or `'users'`
| `batch` | Array     | Yes      | Array of objects you are sending

### Response JSON

> The above command returns a 207 multi status response code

```json
{
    "status": [
        {
            "product_id": "p1",
            "status": "error",
            "error": "Please specify category_1"
        },
        {
            "product_id": "p2",
            "status": "OK"
        }
    ]
}
```

We will send you a status for each item you sent, so you can handle and resend only items that had an error.

## Batch Update Banners / Products / Users

```javascript--browser
"backend only event (refer to the Python, PHP or Node tab)"
```

```php
<?php

$url = "https://api.datacue.co/v1/batch";
$data = array(
  "type" => "users",
  "batch" => array(
    array("first_name" => "Paulo","email" => "u1@abc.com"),
    array("last_name" => "Rabani","email" => "u2@abc.com"),
    array("first_name" => "Hisham","email" => "u3@abc.com"),
  )
);

$content = json_encode($data);

$curl = curl_init($url);
curl_setopt($curl, CURLOPT_HEADER, false);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_HTTPHEADER, array(
  "Content-type" => "application/json",
  "Authorization" => "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
));
curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "PUT");
curl_setopt($curl, CURLOPT_POSTFIELDS, $content);

$json_response = curl_exec($curl);
```

```python
import requests

url = "https://api.datacue.co/v1/batch"
headers = {
  "Content-type": "application/json",
  "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
}
data = {
  "type": "users",
  "batch": [
    {
      "first_name":"Paulo"
      "email":"u1@abc.com"
    },
    {
      "last_name":"Rabani"
      "email":"u2@abc.com"
    },
    {
      "first_name":"Hisham"
      "email":"u3@abc.com"
    }
  ]
}

response = requests.put(url, data=data, headers=headers)
```

```javascript--node
const axios = require('axios');

axios.defaults.baseURL = 'https://api.datacue.co/v1';
axios.defaults.auth = { username: 'API-key', password: 'API-secret' };

const data = {
  type: 'users',
  batch: [{
    first_name: 'Paulo',
    email: 'u1@abc.com'
  }, {
    last_name: 'Rabani',
    email: 'u2@abc.com'
  }, {
    first_name: 'Hisham',
    email: 'u3@abc.com'
  }]
};

axios.put('/batch', data);
```

Endpoint: `PUT` `https://api.datacue.co/v1/batch`

Update multiple banners, products or users. Note that orders cannot be updated only created or cancelled.

### Request parameters

Same as for [Batch Create](#batch-create-banners-orders-products-users).

### Response JSON

> The above command returns a 207 multi status response code

```json
{
    "status": [
        {
            "banner_id": "b1",
            "status": "error",
            "error": "Please specify a photo_url"
        },
        {
            "banner_id": "b2",
            "status": "OK"
        }
    ]
}
```

We will send you a status for each item you sent, so you can handle and resend only items that had an error.

## Batch Delete Banners / Products / Users or Cancel Orders

```javascript--browser
"backend only event (refer to the Python, PHP or Node tab)"
```

```php
<?php

$url = "https://api.datacue.co/v1/batch";
$data = array(
  "type" => "users",
  "batch" => array(
    array("user_id" => "u1"),
    array("user_id" => "u2"),
    array("user_id" => "u3"),
  )
);

$content = json_encode($data);

$curl = curl_init($url);
curl_setopt($curl, CURLOPT_HEADER, false);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_HTTPHEADER, array(
  "Content-type" => "application/json",
  "Authorization" => "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
));
curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "DELETE");
curl_setopt($curl, CURLOPT_POSTFIELDS, $content);

$json_response = curl_exec($curl);
```

```python
import requests

url = "https://api.datacue.co/v1/batch"
headers = {
  "Content-type": "application/json",
  "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
}
data = {
  "type": "users",
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

response = requests.delete(url, data=data, headers=headers)
```

```javascript--node
const axios = require('axios');

axios.defaults.baseURL = 'https://api.datacue.co/v1';
axios.defaults.auth = { username: 'API-key', password: 'API-secret' };

const data = {
  type: "users",
  batch: [{
    user_id: 'u1'
  }, {
    user_id: 'u2'
  }, {
    user_id: 'u3'
  }]
};

axios.delete('/batch', data);
```

Endpoint: `DELETE` `https://api.datacue.co/v1/batch`

Delete/cancel multiple items within one request. Products, banners and users will be deleted. Orders are an exception, 'DELETING' an order marks it as cancelled. Batch DELETE requests only require an id field as follows:

### Request parameters

| Type       | ID Field(s) |
| ---------- | ----------- |
| `banners`  | `banner_id`
| `orders`   | `order_id`
| `products` | `product_id` and `variant_id`
| `users`    | `user_id`

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
