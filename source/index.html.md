---
title: API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - javascript--browser: javascript
  - php
  - python
  - javascript--node: node
includes:
  - errors

search: true
---

# Introduction

Welcome to the DataCue API. This API documentation is to help you setup your e-commerce store to apply real time personalization to your website.

We have language bindings in Javascript, PHP, and Python. You can view code examples in the dark area to the right, and you can switch the programming language of the examples with the tabs in the top right. On a mobile device, switch the language using the hamburger menu on the rop left.

## API URL
The API is located at `https://api.datacue.co`
If you have a staging / test version of your website, you can test your implementation with our staging API at `https://staging-api.datacue.co`.

## Headers

### Authentication

> To authorize, use this code:

```php
<?

$encode = base64_encode("API-key:API-secret");

$auth = "Basic $encode";
?>
```

```python
import base64

auth = "Basic {}".format(base64.b64encode(b"API-key:API-secret").decode("ascii"))
```

```javascript--node
const auth = `Basic ${btoa("API-key:API-secret")}`;
```

```javascript--browser
# for events endpoint, use apikey:
const auth = `Basic ${btoa("API-key:")}`;
```

> Make sure to replace `API-key` with your API key and `API-secret` with your API secret.
>
> Sample Headers

```
  "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
  "Content-Type": "application/json"
```

You can find your API key and API secret in your [DataCue Dashboard](https://app.datacue.co "Dashboard"). 

The `events` endpoint only require an API key to be run from a browser.
All other end-points require both an API key and API secret and should only be run from your backend to keep your API secret... a secret.
We use HTTP Basic Authentication, which encodes the string `apikey:apisecret` into a token that is base64 encoded and prepended with the string "Basic ".

#### Browser Events (only API key):
If your API key is `abc123`, then Base64 encode "abc123:", no password after the colon, and the final result will be "YWJjMTIzOg==".

Your authorization header should look like `Authorization: Basic YWJjMTIzOg==`.

#### Backend End points (API Key and API Secret):
If your API key is `abc123`, and API secret is `secret123` then Base64 encode "abc123:secret123". The final result will be "Basic YWJjMTIzOnNlY3JldDEyMw==".

Your authorization header should look like `Authorization: Basic YWJjMTIzOnNlY3JldDEyMw==`.


### Content-Type

You must set a content-type header to "application/json".
`Content-Type: application/json`

# Browser Events

URL: `POST` `https://api.datacue.co/v1/events`

## Authorization

All events endpoints are meant to be sent from your user's browsers using our embedded script. This endpoint only requires your API Key.

## Format
All events are registered in a similar format. There are 4 main objects in each request.

| Parameter | Required | Description                                                               |
| --------- | -------- | ------------------------------------------------------------------------- |
| user      | true     | All data that we know about the current user at the time.       |
| event     | true     | Details about the event                                         |
| context   | false    | Details about the user’s device and location                    |
| timestamp | false    | An ISO-8601 date string in UTC time for when the event happened |

<aside class="success">
  Parameter breakdown
</aside>

### User

**Field**|**Data Type**|**Description**|**Mandatory**
:-----:|:-----:|:-----:|:-----:
user\_id|String|The unique user id if the user has logged in|Yes (if logged in)
anonymous\_id|String|An automatically generated visitor id if the user has not logged in. |Yes (if not logged in)
 | |If you send us both a user\_id and anonymous\_id we will record the user\_id| 
profile|JSON Object|Any user segmentation data you know about the user, see the table below for details.|No

### Profile

**Field**|**Data Type**|**Description**|**Mandatory**
:-----:|:-----:|:-----:|:-----:
sex|String|Sex of the user|No
segment|String|Custom segment name that you store e.g. Gold class / Member |No
location|String|Location of the user as a commune, city, region or country|No

The above are the most common types of profile segments, since it's a JSON object you can specify any other fields you wish to use for personalization.

### Event

Field descriptions differ per event type. Please refer to the event descriptions below to know what fields are required.

### Context

OPTIONAL. We use incoming HTTP headers to fill in this object, therefore this object is optional. You can specify context if you are sending historical data, or have any other special requirements that require overriding the default headers.

Refer to the example json on the right to view the format.

```json
  "context": {
    "ip": "12.34.56.78",
    "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  }
```

**Field**|**Data Type**|**Description**|**Mandatory**
:-----:|:-----:|:-----:|:-----:
ip|text|IP address|No
user\_agent|String|User agent string of the browser|No

### Timestamp

OPTIONAL. Only required if you're sending us historical events, if not, we log the event at the time we received it.

Refer to the example json on the right to view the format.

```json
  "timestamp": "2018-01-23T00:30:08.276Z"
```

**Field**|**Data Type**|**Description**|**Mandatory**
:-----:|:-----:|:-----:|:-----:
timestamp|ISO 8601 date|The current time in UTC for when the event happened. E.g. "2017-11-01T00:29:03.123Z"|No


## Home Page View

Request banner and product recommendations when a user visits your home page

**Field**|**Data Type**|**Description**|**Mandatory**
:-----:|:-----:|:-----:|:-----:
type|String|Set to 'pageview'|Yes
subtype|String|Set to 'home'|Yes

```javascript--browser
const url = "https://api.datacue.co/v1/events";
let data = {
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
// The parameters we are going to pass to the fetch function
let fetchData = {
    method: "POST",
    body: data,
    headers: new Headers(
      "Content-Type", "application/json",
      "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
    )
}
fetch(url, fetchData)
.then((res) => res.json())
.then((data) =>  console.log(data))
.catch((err) => console.log(err))
```

```php
<?
//browser only event (refer to the javascript tab)
?>
```

```python
#browser only event (refer to the javascript tab)
```

```javascript--node
//browser only event (refer to the javascript tab)
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
      "link": "/product/table-1",
      "name": "Modern Table",
      "price": 219,
      "photo_url": "/products/48.jpg",
      "category_1": "kitchen",
      "product_id": "48"
    },
    {
      "link": "/product/rack-4",
      "name": "Sturdy Rack",
      "price": 49,
      "photo_url": "/products/8.jpg",
      "category_1": "bathroom",
      "product_id": "8"
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
}
```

**Field**|**Data Type**|**Description**
:-----:|:-----:|:-----:|:-----:
main_banners|Array|An array of banner objects recommended for the current user
sub_banners|Array|An array of sub banner objects recommended for the current user
related_product_skus|Array|An array of product objects recommended for the current user
recent_product_skus|Array|A live list of the last products the current user has viewed

## Product Page View

Request product recommendations when a user visits a product page

**Response Field**|**Data Type**|**Description**|**Mandatory**
:-----:|:-----:|:-----:|:-----:
type|String|Set to 'pageview'|Yes
subtype|String|Set to 'product'|Yes
product_id|String|Set to product id being viewed|Yes

```javascript--browser
const url = "https://api.datacue.co/v1/events";
let data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "07d35b1a-5776-4ddf-8f1c-dd0d2db9c502",
    "profile": {
  	  "sex": "female",
  	  "location": "santiago",
      "segment": "platinum"
    }
  },
  "event": {
  	"type": "pageview",
    "subtype": "product",
    "product_id": "p1",
    "variant_id": "v1"
  }
}
// The parameters we are going to pass to the fetch function
let fetchData = {
    method: "POST",
    body: data,
    headers: new Headers(
      "Content-Type", "application/json",
      "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
      )
}
fetch(url, fetchData)
.then((res) => res.json())
.then((data) =>  console.log(data))
.catch((err) => console.log(err))
```

```php
<?
//browser only event (refer to the javascript tab)
?>
```

```python
#browser only event (refer to the javascript tab)
```

```javascript--node
//browser only event (refer to the javascript tab)
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
      "link": "/product/towel-2",
      "name": "Soft Towel",
      "price": 39,
      "photo_url": "/products/2.jpg",
      "category_1": "bathroom",
      "product_id": "2"
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
      "link": "/product/sofa-3",
      "name": "Modern Sofa",
      "price": 259,
      "photo_url": "/products/58.jpg",
      "category_1": "living-room",
      "product_id": "58"
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

**Response Field**|**Data Type**|**Description**
:-----:|:-----:|:-----:|:-----:
similar_product_skus|Array|An array of product objects with similar characteristics to the current product
related_product_skus|Array|An array of product objects that are frequently bought with the current product
recent_product_skus|Array|A live list of the last products the current user has viewed


## Category Page View

Pages showing multiple products on a page, these are commonly called category, collection or catalog pages.

**Field**|**Data Type**|**Description**|**Mandatory**
:-----:|:-----:|:-----:|:-----:
type|String|Set to 'pageview'|Yes
subtype|String|Set to 'category'|Yes
category_name|String|Set to the name of the category being viewed|Yes


```javascript--browser
const url = "https://api.datacue.co/v1/events";
let data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "07d35b1a-5776-4ddf-8f1c-dd0d2db9c502",
    "profile": {
  	  "sex": "female",
  	  "location": "santiago",
      "segment": "platinum"
    }
  },
  "event": {
  	"type": "pageview",
    "subtype": "category",
    "category_name": "living-room"
  }
}
// The parameters we are going to pass to the fetch function
let fetchData = {
    method: "POST",
    body: data,
    headers: new Headers(
      "Content-Type", "application/json",
      "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
      )
}
fetch(url, fetchData)
.then((res) => res.json())
.then((data) =>  console.log(data))
.catch((err) => console.log(err))
```

```php
<?
//browser only event (refer to the javascript tab)
?>
```

```python
#browser only event (refer to the javascript tab)
```

```javascript--node
//browser only event (refer to the javascript tab)
```

> The above command returns a 204 response code


## Shopping Cart Updated / Viewed

Record activity on a users shopping cart, typically when the cart is viewed, or an item is added or removed.

**Field**|**Data Type**|**Description**|**Mandatory**
:-----:|:-----:|:-----:|:-----:
type|String|Set to 'viewcart'|Yes
cart|Array|Specify an array of product_ids and optionally variant_ids|Yes


```javascript--browser
const url = "https://api.datacue.co/v1/events";
let data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "07d35b1a-5776-4ddf-8f1c-dd0d2db9c502",
    "profile": {
  	  "sex": "female"
    }
  },
  "event": {
    "type": "viewcart",
    "cart": [{
                "product_id":"p1",
                "variant_id":"v1"
              },{
                "product_id":"p2",
                "variant_id":"v1"
              },{
                "product_id":"p3",
                "variant_id":"v1"
              }
          ]
  }
}
// The parameters we are going to pass to the fetch function
let fetchData = {
    method: "POST",
    body: data,
    headers: new Headers(
      "Content-Type", "application/json",
      "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
      )
}
fetch(url, fetchData)
.then((res) => res.json())
.then((data) =>  console.log(data))
.catch((err) => console.log(err))
```

```php
<?
//browser only event (refer to the javascript tab)
?>
```

```python
#browser only event (refer to the javascript tab)
```

```javascript--node
//browser only event (refer to the javascript tab)
```

> The above command returns JSON structured like this:

```json
{
  "related_product_skus": [
    {
      "product_id": "37",
      "variant_id": "v1",
      "category_1": "outdoors",
      "category_2": "sofa",
      "name": "Outdoor Armchair",
      "link": "/outdoor-sofa-2",
      "price": "199",
      "photo_url": "/products/37.jpg",
      "extras": {"discount":"10%"}
    }, {
      "product_id": "45",
      "variant_id": "v1",
      "category_1": "living-room",
      "category_2": "lamp",
      "name": "Beautiful lamp",
      "link": "/living-room/45",
      "price": "49",
      "photo_url": "/products/45.jpg",
      "extras": {}
    },
  ]
}
```

## Search

Record when a user performs a search on your website

**Field**|**Data Type**|**Description**|**Mandatory**
:-----:|:-----:|:-----:|:-----:
type|String|Set to 'search'|Yes
term|String|Set to the user's search term|Yes

```javascript--browser
const url = "https://api.datacue.co/v1/events";
let data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "07d35b1a-5776-4ddf-8f1c-dd0d2db9c502",
    "profile": {
  	  "sex": "female"
    }
  },
  "event": {
    "type": "search",
    "term": "tables"
  }
}
// The parameters we are going to pass to the fetch function
let fetchData = {
    method: "POST",
    body: data,
    headers: new Headers(
      "Content-Type", "application/json",
      "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
      )
}
fetch(url, fetchData)
.then((res) => res.json())
.then((data) =>  console.log(data))
.catch((err) => console.log(err))
```

```php
<?
//browser only event (refer to the javascript tab)
?>
```

```python
#browser only event (refer to the javascript tab)
```

```javascript--node
//browser only event (refer to the javascript tab)
```

> The above command returns JSON structured like this:

```json
{
  "related_product_skus": [
    {
      "product_id": "37",
      "variant_id": "1",
      "category_1": "outdoors",
      "category_2": "sofa",
      "category_3": "scandinavian",
      "category_4": "modern",
      "name": "Outdoor Armchair",
      "link": "/outdoor-sofa-2",
      "price": "199",
      "photo_url": "/products/37.jpg",
      "extras": {"discount":"10%"}
    },
  ]
}
```
## Add Product to Wishlist

Record changes to users wishlist, typically when the wishlist is viewed, or a product is added or removed from the wishlist.

**Field**|**Data Type**|**Description**|**Mandatory**
:-----:|:-----:|:-----:|:-----:
type|String|Set to 'wishlist'|Yes
subtype|String|Set to 'add'|Yes
product_id|String|id of added product|Yes
variant_id|String|id of product variant|No


```javascript--browser
const url = "https://api.datacue.co/v1/events";
let data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "07d35b1a-5776-4ddf-8f1c-dd0d2db9c502a1",
    "profile": {
  	  "sex": "female"
    }
  },
  "event": {
    "type": "wishlist",
    "subtype":"add",
    "product_id": "p1",
    "variant_id": "v2"
  }
}
// The parameters we are going to pass to the fetch function
let fetchData = {
    method: "PUT",
    body: data,
    headers: new Headers(
      "Content-Type", "application/json",
      "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
      )
}
fetch(url, fetchData)
.then((res) => res.json())
.then((data) =>  console.log(data))
.catch((err) => console.log(err))
```

```php
<?
//browser only event (refer to the javascript tab)
?>
```

```python
#browser only event (refer to the javascript tab)
```

```javascript--node
//browser only event (refer to the javascript tab)
```

> The above command returns a 204 response code

## Remove Product from Wishlist

Record changes to users wishlist, typically when the wishlist is viewed, or a product is added or removed from the wishlist.

**Field**|**Data Type**|**Description**|**Mandatory**
:-----:|:-----:|:-----:|:-----:
type|String|Set to 'wishlist'|Yes
subtype|String|Set to 'remove'|Yes
product_id|String|id of added product|Yes
variant_id|String|id of product variant|No


```javascript--browser
const url = "https://api.datacue.co/v1/events";
let data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "07d35b1a-5776-4ddf-8f1c-dd0d2db9c502a1",
    "profile": {
      "sex": "female"
    }
  },
  "event": {
    "type": "wishlist",
    "subtype":"remove",
    "product_id": "p1",
    "variant_id": "v2"
  }
}
// The parameters we are going to pass to the fetch function
let fetchData = {
    method: "PUT",
    body: data,
    headers: new Headers(
      "Content-Type", "application/json",
      "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
      )
}
fetch(url, fetchData)
.then((res) => res.json())
.then((data) =>  console.log(data))
.catch((err) => console.log(err))
```

```php
<?
//browser only event (refer to the javascript tab)
?>
```

```python
#browser only event (refer to the javascript tab)
```

```javascript--node
//browser only event (refer to the javascript tab)
```

> The above command returns a 204 response code

## Banner Click

Record clicks to a banner or a sub banner, typically on your home page

**Field**|**Data Type**|**Description**|**Mandatory**
:-----:|:-----:|:-----:|:-----:
type|String|Set to 'click'|Yes
subtype|String|Set to 'banner'|Yes
banner_id|String|Set to the id of the clicked banner|Yes


```javascript--browser
const url = "https://api.datacue.co/v1/events";
let data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "07d35b1a-5776-4ddf-8f1c-dd0d2db9c502a1",
    "profile": {
  	  "sex": "mujer"
    }
  },
  "event": {
    "type": "click",
    "subtype": "banner",
    "banner_id": "b1"
  }
}
// The parameters we are going to pass to the fetch function
let fetchData = {
    method: "POST",
    body: data,
    headers: new Headers(
      "Content-Type", "application/json",
      "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
      )
}
fetch(url, fetchData)
.then((res) => res.json())
.then((data) =>  console.log(data))
.catch((err) => console.log(err))
```

```php
<?
//browser only event (refer to the javascript tab)
?>
```

```python
#browser only event (refer to the javascript tab)
```

```javascript--node
//browser only event (refer to the javascript tab)
```


> The above command returns a 204 response code

## Product Click

Record clicks on a product anywhere on your website.

**Field**|**Data Type**|**Description**|**Mandatory**
:-----:|:-----:|:-----:|:-----:
type|String|Set to 'click'|Yes
subtype|String|Set to 'product'|Yes
product_id|String|Set to the id of the clicked product|Yes


```javascript--browser
const url = "https://api.datacue.co/v1/events";
let data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "07d35b1a-5776-4ddf-8f1c-dd0d2db9c502a1",
    "profile": {
  	  "sex": "female"
    }
  },
  "event": {
    "type": "click",
    "subtype": "product",
    "product_id": "p2"
  }
}
// The parameters we are going to pass to the fetch function
let fetchData = {
    method: "POST",
    body: data,
    headers: new Headers(
      "Content-Type", "application/json",
      "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
      )
}
fetch(url, fetchData)
.then((res) => res.json())
.then((data) =>  console.log(data))
.catch((err) => console.log(err))
```

```php
<?
//browser only event (refer to the javascript tab)
?>
```

```python
#browser only event (refer to the javascript tab)
```

```javascript--node
//browser only event (refer to the javascript tab)
```

> The above command returns a 204 response code

## Start Order (Check Out Started)

Record the moment the user initiates the check out process, typically from their shopping cart.

**Field**|**Data Type**|**Description**|**Mandatory**
:-----:|:-----:|:-----:|:-----:
type|String|Set to 'order'|Yes
subtype|String|Set to 'started'|Yes
order_id|String|Set to the id of the order (if available)|No
cart|Array|Cart contents as an array of product, variant, unit price, quantity and currency|Yes


```javascript--browser
const url = "https://api.datacue.co/v1/events";
let data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "07d35b1a-5776-4ddf-8f1c-dd0d2db9c502a1",
    "profile": {
  	  "sex": "female"
    }
  },
  "event": {
    "type": "order",
    "subtype": "started",
    "order_id": "o1",
    "cart": [
      {
        "product_id": "p1",
        "variant": "v1",
        "quantity": 1,
        "price": 24,
        "currency": "USD"
      }
    ]
  }
}
// The parameters we are going to pass to the fetch function
let fetchData = {
    method: "POST",
    body: data,
    headers: new Headers(
      "Content-Type", "application/json",
      "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
      )
}
fetch(url, fetchData)
.then((res) => res.json())
.then((data) =>  console.log(data))
.catch((err) => console.log(err))
```

```php
<?
//browser only event (refer to the javascript tab)
?>
```

```python
#browser only event (refer to the javascript tab)
```

```javascript--node
//browser only event (refer to the javascript tab)
```

> The above command returns a 204 response code

## Complete Order

Record the moment the order (or checkout) is completed.

**Field**|**Data Type**|**Description**|**Mandatory**
:-----:|:-----:|:-----:|:-----:
type|String|Set to 'order'|Yes
subtype|String|Set to 'completed'|Yes
order_id|String|Set to the id of the order|Yes
cart|Array|Cart contents as an array of product, variant, unit price, quantity and currency|Yes
payment_method|String|Specify the payment method used (for analytics)|No


```javascript--browser
const url = "https://api.datacue.co/v1/events";
let data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "07d35b1a-5776-4ddf-8f1c-dd0d2db9c502a1",
    "profile": {
  	  "sex": "female"
    }
  },
  "event": {
    "type": "order",
    "subtype": "completed",
    "order_id": "o1",
    "buyer_id": "",
    "payment_method": "",
    "cart": [
      {
        "product_id": "p1",
        "variant_id": "v1",
        "quantity": 1,
        "unit_price": 24000,
        "currency": "USD"
      }
    ]
  }
}
// The parameters we are going to pass to the fetch function
let fetchData = {
    method: "POST",
    body: data,
    headers: new Headers(
      "Content-Type", "application/json",
      "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
      )
}
fetch(url, fetchData)
.then((res) => res.json())
.then((data) =>  console.log(data))
.catch((err) => console.log(err))
```

```php
<?
//browser only event (refer to the javascript tab)
?>
```

```python
#browser only event (refer to the javascript tab)
```

```javascript--node
//browser only event (refer to the javascript tab)
```

> The above command returns a 204 response code

## Cancel Order

Record the moment the order (or checkout) is cancelled.

**Field**|**Data Type**|**Description**|**Mandatory**
:-----:|:-----:|:-----:|:-----:
type|String|Set to 'order'|Yes
subtype|String|Set to 'cancelled'|Yes
order_id|String|Set to the id of the order|Yes


```javascript--browser
const url = "https://api.datacue.co/v1/events";
let data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "07d35b1a-5776-4ddf-8f1c-dd0d2db9c502a1",
    "profile": {
  	  "sex": "female"
    }
  },
  "event": {
    "type": "order",
    "subtype": "cancelled",
    "order_id": "o1"
  }
}
// The parameters we are going to pass to the fetch function
let fetchData = {
    method: "POST",
    body: data,
    headers: new Headers(
      "Content-Type", "application/json",
      "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
      )
}
fetch(url, fetchData)
.then((res) => res.json())
.then((data) =>  console.log(data))
.catch((err) => console.log(err))
```

```php
<?
//browser only event (refer to the javascript tab)
?>
```

```python
#browser only event (refer to the javascript tab)
```

```javascript--node
//browser only event (refer to the javascript tab)
```

> The above command returns a 204 response code

## User Login

Record logins by a user on your website, if the user login is cached, you do not need to fire this event when the user returns.

**Field**|**Data Type**|**Description**|**Mandatory**
:-----:|:-----:|:-----:|:-----:
type|String|Set to 'login'|Yes

```javascript--browser
const url = "https://api.datacue.co/v1/events";
let data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "07d35b1a-5776-4ddf-8f1c-dd0d2db9c502a1",
    "profile": {
  	  "sex": "female"
    }
  },
  "event": {
    "type": "login"
  }
}
// The parameters we are going to pass to the fetch function
let fetchData = {
    method: "POST",
    body: data,
    headers: new Headers(
      "Content-Type", "application/json",
      "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
      )
}
fetch(url, fetchData)
.then((res) => res.json())
.then((data) =>  console.log(data))
.catch((err) => console.log(err))
```

```php
<?
//browser only event (refer to the javascript tab)
?>
```

```python
#browser only event (refer to the javascript tab)
```

```javascript--node
//browser only event (refer to the javascript tab)
```

> The above command returns a 204 response code

# Products

## Create Product

URL: `POST` `https://api.datacue.co/v1/products`

Whenever a new product is created, send this request from your backend.

**Field**|**Data Type**|**Description**|**Mandatory**
:-----:|:-----:|:-----:|:-----:
product_id|String|The product id or SKU number|Yes
variant_id|String|A unique variant id within the product id, if you only use product SKUs set this to a constant such as 'no-variants'|Yes
category_1|String|Top category level of product e.g. 'Men' , 'Women' or 'Children''.|Yes
category_2|String|Second category level of product e.g. 'Shoes' or 'Dresses'|No
category_3|String|Third category level of product e.g. 'Sports' or 'Sandals'|No
category_4|String|Fourth category level of product e.g. 'Running shoes'|No
category_extra|JSON Object|Any other categories can be stored here as an object, e.g. "category_extra" : { "category_5": "value" } and so on.|No
name|String|Name or Title of the product|Yes
brand|String|Brand name of the product|No
description|String|Long text description of the product|No
color|String|Color of the product|No
size|String|Size of the product|No
price|Decimal|Price of the product up to two decimal places|Yes
available|Boolean|Is the product available for Sale (Default true)|No
stock|Integer|Number of product in stock|Yes
extra|JSON Object|Any other fields you want to store about the product that you want to display on site e.g. discounts or promotions. |No
photo_url|String|URL of the photo, you can use relative URLs as this is purely for your front-end to request the image|Yes
link|String|URL of product page for this product e.g. /products/p1|Yes
owner_id|String|If you're running a marketplace, store the product's owner or seller's user ID here.|No

```javascript--browser
//backend only event (refer to the python, php or node tab)
```

```php
<?
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
curl_setopt($curl, CURLOPT_HTTPHEADER,
        array(
          "Content-type: application/json",
          "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
        ));
curl_setopt($curl, CURLOPT_POST, true);
curl_setopt($curl, CURLOPT_POSTFIELDS, $content);

$json_response = curl_exec($curl);
?>
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
const url = "https://api.datacue.co/v1/products";
let data = {
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
// The parameters we are going to pass to the fetch function
let fetchData = {
    method: "POST",
    body: data,
    headers: new Headers(
      "Content-Type", "application/json",
      "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
      )
}
fetch(url, fetchData)
.then((res) => res.json())
.then((data) =>  console.log(data))
.catch((err) => console.log(err))
```

> The above command returns a 201 response code


## Update Product

URL: `PUT` `https://api.datacue.co/v1/products/<product_id>/<variant_id>`

Whenever an existing product is updated such as image, name, price or new discounts, send this request from your backend.

Remember that when an order is completed this is also a product update as the stock level of the product will change. Sending us a product update after an order will ensure that if a product is out of stock, it is no longer recommended to other users.

```javascript--browser
//backend only event (refer to the python, php or node tab)
```

```php
<?
$url = "https://api.datacue.co/v1/products/:product_id/:variant_id";
$data = array(
  "category_1" => "men",
  "category_2" => "jeans",
  "category_3" => "skinny",
  "stock" => 6,
  "available" => False
);

$content = json_encode($data);

$curl = curl_init($url);
curl_setopt($curl, CURLOPT_HEADER, false);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_HTTPHEADER,
        array(
          "Content-type: application/json",
          "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
        ));
curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "PUT");
curl_setopt($curl, CURLOPT_POSTFIELDS, $content);

$json_response = curl_exec($curl);
?>
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
const url = "https://api.datacue.co/v1/products/:product_id/:variant_id";
let data = {
   "category_1": "men",
   "category_2": "jeans",
   "category_3": "skinny"
   "stock": 6,
   "available": false
 }
// The parameters we are going to pass to the fetch function
let fetchData = {
    method: "PUT",
    body: data,
    headers: new Headers(
      "Content-Type", "application/json",
      "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
      )
}
fetch(url, fetchData)
.then((res) => res.json())
.then((data) =>  console.log(data))
.catch((err) => console.log(err))
```

> The above command returns a 204 response code

## Delete Product

Delete a variant

URL: `DELETE` `https://api.datacue.co/v1/products/<product_id>/<variant_id>`

Delete a product and all associated variants

URL: `DELETE` `https://api.datacue.co/v1/products/<product_id>`

Delete a product on your system.

```javascript--browser
//backend only event (refer to the python, php or node tab)
```

```php
<?
$url = "https://api.datacue.co/v1/products/:product_id/:variant_id";

$curl = curl_init($url);
curl_setopt($curl, CURLOPT_HEADER, false);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_HTTPHEADER,
        array(
          "Content-type: application/json",
          "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
        ));
curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "DELETE");

$json_response = curl_exec($curl);
?>
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
const url = "https://api.datacue.co/v1/products/:product_id/:variant_id";

// The parameters we are going to pass to the fetch function
let fetchData = {
  method: "DELETE",
  headers: new Headers(
    "Content-Type", "application/json",
    "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
  )
}
fetch(url, fetchData)
.then((res) => res.json())
.then((data) =>  console.log(data))
.catch((err) => console.log(err))
```

> The above command returns a 204 response code


# Banners

We recommend that you use your DataCue dashboard to upload and manage your banners. However, if you want DataCue to use your existing banner management solution, you can use these endpoints to do so.

## Create Banner

URL: `POST` `https://api.datacue.co/v1/banners`

When you create a new banner on your system.

**Field**|**Data Type**|**Description**|**Mandatory**
:-----:|:-----:|:-----:|:-----:
banner_id|String|The product id or SKU number|Yes
type|String|The type of banner. Set to 'main' for main banner or 'sub' for sub banner|Yes
name|String|Friendly name for the banner|No
category_1|String|The top category level this product belongs to. In a fashion store, this could be 'Men' , 'Women' or 'Children''.|Yes
category_2|String|The second category level this product belongs to. In a fashion store, this could be 'Shoes or 'Dresses'|No
category_3|String|The third category level this product belongs to. In a fashion store, this could be 'Sports' or 'Sandals'|No
category_4|String|The fourth category level this product belongs to. In a fashion store, this could be 'Running shoes'|No
photo_url|String|URL of the banner image, you can use relative URLs as this is purely for your front-end to request the image|Yes
link|String|Which page to take the user to when they click on the banner on your website. Typically a collection or catalog page for the banner's associated category.|Yes
extra|JSON Object|Any other information you would like to use for special processing in the browser.|No

```javascript--browser
//backend only event (refer to the python, php or node tab)
```

```php
<?
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
  "photos" => array(
      "meta" => "any field you want to store"
  )
);

$content = json_encode($data);

$curl = curl_init($url);
curl_setopt($curl, CURLOPT_HEADER, false);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_HTTPHEADER,
        array(
          "Content-type: application/json",
          "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
        ));
curl_setopt($curl, CURLOPT_POST, true);
curl_setopt($curl, CURLOPT_POSTFIELDS, $content);

$json_response = curl_exec($curl);
?>
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
const url = "https://api.datacue.co/v1/banners";
let data = {
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

// The parameters we are going to pass to the fetch function
let fetchData = {
    method: "POST",
    body: data,
    headers: new Headers(
      "Content-Type", "application/json",
      "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
      )
}
fetch(url, fetchData)
.then((res) => res.json())
.then((data) =>  console.log(data))
.catch((err) => console.log(err))
```

> The above command returns a 201 response code


## Update Banner

URL: `PUT` `https://api.datacue.co/v1/banners/<banner_id>`

When you update your banner in any way like changing the banner image, link or assigned categories on your system. Does not apply if you're using DataCue to manage your banners.

Only send fields to be updated

```javascript--browser
//backend only event (refer to the python, php or node tab)
```

```php
<?
$url = "https://api.datacue.co/v1/banners/:banner_id";
$data = array(
  "link" => "/new-link"
);

$content = json_encode($data);

$curl = curl_init($url);
curl_setopt($curl, CURLOPT_HEADER, false);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_HTTPHEADER,
        array(
          "Content-type: application/json",
          "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
        ));
curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "PUT");
curl_setopt($curl, CURLOPT_POSTFIELDS, $content);

$json_response = curl_exec($curl);
?>
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
const url = "https://api.datacue.co/v1/banners/:banner_id";
let data = {
   "link": "/new-link"
 }
// The parameters we are going to pass to the fetch function
let fetchData = {
    method: "PUT",
    body: data,
    headers: new Headers(
      "Content-Type", "application/json",
      "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
      )
}
fetch(url, fetchData)
.then((res) => res.json())
.then((data) =>  console.log(data))
.catch((err) => console.log(err))
```

> The above command returns a 204 response code

## Delete Banner

URL: `DELETE` `https://api.datacue.co/v1/banners/<banner_id>`

When you delete a banner on your system. Does not apply if you're using DataCue to manage your banners.

```javascript--browser
//backend only event (refer to the python, php or node tab)
```

```php
<?
$url = "https://api.datacue.co/v1/banners/:banner_id";

$curl = curl_init($url);
curl_setopt($curl, CURLOPT_HEADER, false);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_HTTPHEADER,
        array(
          "Content-type: application/json",
          "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
        ));
curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "DELETE");

$json_response = curl_exec($curl);
?>
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
const url = "https://api.datacue.co/v1/banners/:banner_id";

// The parameters we are going to pass to the fetch function
let fetchData = {
  method: "DELETE",
  headers: new Headers(
    "Content-Type", "application/json",
    "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
  )
}
fetch(url, fetchData)
.then((res) => res.json())
.then((data) =>  console.log(data))
.catch((err) => console.log(err))
```

> The above command returns a 204 response code


# Users

## Create User

URL: `POST` `https://api.datacue.co/v1/users`

When a new user has successfully signed up / registered on your system.

**Field**|**Data Type**|**Description**|**Mandatory**
:-----:|:-----:|:-----:|:-----:
user\_id|String|The unique user id assigned|Yes
anonymous\_id|String|Anonymous ID that was previously associated with this user prior to user sign up|No
email|String|User's email address|Yes, if using email marketing
title|String|Salutation e.g. Mr. , Ms., Dr.|No
first\_name|String|User's first name, if you store all the names in one field assign the name to this field|Yes
last\_name|String|User's last name|No
profile|JSON object|User's profile. See table below for field description|No
email_subscriber|Boolean|Has this user consented to receive marketing email?|No
cart|Array|An array of product ids and variant ids representing the current products in the users shopping cart.|No
timestamp|ISO 8601 Date| User creation date/time in UTC timezone|No

### Profile

**Field**|**Data Type**|**Description**|**Mandatory**
:-----:|:-----:|:-----:|:-----:
sex|String|Sex of the user|No
location|String|Aggregate location like commune, city or country of the user|No
segment|String|Custom segment name that you store e.g. Gold class / Member|No

```javascript--browser
//backend only event (refer to the python, php or node tab)
```

```php
<?
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
  "email_subscriber" => True,
  "cart" => array(
    array("product_id" => "p1","variant_id" => "v1"),
    array("product_id" => "p2","variant_id" => "v1")
  ),
  "timestamp" => "2018-04-04T23:29:04-03:00"
)

$content = json_encode($data);

$curl = curl_init($url);
curl_setopt($curl, CURLOPT_HEADER, false);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_HTTPHEADER,
        array(
          "Content-type: application/json",
          "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
        ));
curl_setopt($curl, CURLOPT_POST, true);
curl_setopt($curl, CURLOPT_POSTFIELDS, $content);

$json_response = curl_exec($curl);
?>
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
       "product_id":"p1",
       "variant_id":"v1"
     },
     {
       "product_id":"p2",
       "variant_id":"v1"
     }
  ],
  "timestamp":"2018-04-04T23:29:04-03:00"
}

response = requests.post(url, data=data, headers=headers)
```

```javascript--node
const url = "https://api.datacue.co/v1/users";
let data = {
   "user_id": "u1",
   "anonymous_ids": "v1",
   "email": "xyz@abc.com",
   "title": "Mr",
   "first_name": "Noob",
   "last_name": "Saibot",
   "profile": {
       "location": "santiago",
       "sex": "male",
       "segment": "platinum"
   },
   "email_subscriber": true,
   "cart": [
     {
       "product_id":"p1",
       "variant_id":"v1"
     },
     {
       "product_id":"p2",
       "variant_id":"v1"
     }
  ],
  "timestamp":"2018-04-04T23:29:04-03:00"
}

// The parameters we are going to pass to the fetch function
let fetchData = {
    method: "POST",
    body: data,
    headers: new Headers(
      "Content-Type", "application/json",
      "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
      )
}
fetch(url, fetchData)
.then((res) => res.json())
.then((data) =>  console.log(data))
.catch((err) => console.log(err))
```

> The above command returns a 201 response code


## Update User

URL: `PUT` `https://api.datacue.co/v1/users/<user_id>`

When the user makes changes to their profile or when they configure any relevant preferences. For instance if they indicate their gender, this is very helpful for recommendations.

```javascript--browser
//backend only event (refer to the python, php or node tab)
```

```php
<?
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
curl_setopt($curl, CURLOPT_HTTPHEADER,
        array(
          "Content-type: application/json",
          "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
        ));
curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "PUT");
curl_setopt($curl, CURLOPT_POSTFIELDS, $content);

$json_response = curl_exec($curl);
?>
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
const url = "https://api.datacue.co/v1/users/:user_id";
let data = {
   "profile": {
     "location" : "singapore"
   }
 }
// The parameters we are going to pass to the fetch function
let fetchData = {
    method: "PUT",
    body: data,
    headers: new Headers(
      "Content-Type", "application/json",
      "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
      )
}
fetch(url, fetchData)
.then((res) => res.json())
.then((data) =>  console.log(data))
.catch((err) => console.log(err))
```

> The above command returns a 204 response code

## Delete User

URL: `DELETE` `https://api.datacue.co/v1/users/<user_id>`

When a user account is deleted from your system.

```javascript--browser
//backend only event (refer to the python, php or node tab)
```

```php
<?
$url = "https://api.datacue.co/v1/users/:user_id";

$curl = curl_init($url);
curl_setopt($curl, CURLOPT_HEADER, false);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_HTTPHEADER,
        array(
          "Content-type: application/json",
          "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
        ));
curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "DELETE");

$json_response = curl_exec($curl);
?>
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
const url = "https://api.datacue.co/v1/users/:user_id";

// The parameters we are going to pass to the fetch function
let fetchData = {
  method: "DELETE",
  headers: new Headers(
    "Content-Type", "application/json",
    "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
  )
}
fetch(url, fetchData)
.then((res) => res.json())
.then((data) =>  console.log(data))
.catch((err) => console.log(err))
```

> The above command returns a 204 response code

# Batch

## Batch Create Banners / Orders / Products / Users

URL: `POST` `https://api.datacue.co/v1/batch`

Use the batch endpoint if you want to do a bulk import, typically when you first start using DataCue and you want to add your historical orders, products or users.

Tell us what you're sending via the 'type' and insert an array of your requests in the batch field.

Best explained with an example: lets say you want to create 500 products in one go. As seen in the previous section, a product create payload looks like this:
```json
{
  "product_id":"P1",
  "variant_id":"V2",
  "category_1":"jeans",
  "price":50,
  "photo_url":"/products/p1.jpg",
  "link":"/products/p1"
}
```

to submit multiple, just set type to "products" and insert an array of product requests in the batch field like so:

```json
{
  "type":"products",
  "batch": [{
    "product_id":"P1",
    "variant_id":"V2",
    "category_1":"jeans",
    "price":50,
    "photo_url":"/products/p1.jpg",
    "link":"/products/p1"
  },{
    "product_id":"P2",
    "variant_id":"V1",
    "category_1":"shirts",
    "price":30,
    "photo_url":"/products/p2.jpg",
    "link":"/products/p2"
  }]
}
```

**Field**|**Data Type**|**Description**|**Mandatory**
:-----:|:-----:|:-----:|:-----:
type|String|Set to products, orders or users|Yes
batch|Array|Array of objects you are sending|Yes

```javascript--browser
//backend only event (refer to the python, php or node tab)
```

```javascript--browser
//backend only event (refer to the python, php or node tab)
```

```php
<?
$url = "https://api.datacue.co/v1/batch";
$data = array(
  "type" => "users",
  "batch" => array(
    array("user_id" => "u1","email" => "u1@abc.com"),
    array("user_id" => "u2","email" => "u2@abc.com"),
    array("user_id" => "u3","email" => "u3@abc.com"),
  )
)

$content = json_encode($data);

$curl = curl_init($url);
curl_setopt($curl, CURLOPT_HEADER, false);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_HTTPHEADER,
        array(
          "Content-type: application/json",
          "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
        ));
curl_setopt($curl, CURLOPT_POST, true);
curl_setopt($curl, CURLOPT_POSTFIELDS, $content);

$json_response = curl_exec($curl);
?>
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
       "user_id":"u1"
       "email":"u1@abc.com"
     },
     {
       "user_id":"u2"
       "email":"u2@abc.com"
     },
     {
       "user_id":"u3"
       "email":"u3@abc.com"
     }
  ]
}

response = requests.post(url, data=data, headers=headers)
```

```javascript--node
const url = "https://api.datacue.co/v1/batch";
let data = {
   "type": "users",
   "batch": [
     {
       "user_id":"u1"
       "email":"u1@abc.com"
     },
     {
       "user_id":"u2"
       "email":"u2@abc.com"
     },
     {
       "user_id":"u3"
       "email":"u3@abc.com"
     }
  ]
}

// The parameters we are going to pass to the fetch function
let fetchData = {
    method: "POST",
    body: data,
    headers: new Headers(
      "Content-Type", "application/json",
      "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
      )
}
fetch(url, fetchData)
.then((res) => res.json())
.then((data) =>  console.log(data))
.catch((err) => console.log(err))
```

> The above command returns a 207 multi status response code

We will send you a status for each item you sent, so you can handle and resend only items that had an error.

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

## Batch Update Banners / Products / Users

URL: `PUT` `https://api.datacue.co/v1/batch`

Update multiple banners, products or users. Note that orders cannot be updated only created or cancelled.


```javascript--browser
//backend only event (refer to the python, php or node tab)
```

```php
<?
$url = "https://api.datacue.co/v1/batch";
$data = array(
  "type" => "users",
  "batch" => array(
    array("first_name" => "Paulo","email" => "u1@abc.com"),
    array("last_name" => "Rabani","email" => "u2@abc.com"),
    array("first_name" => "Hisham","email" => "u3@abc.com"),
  )
)

$content = json_encode($data);

$curl = curl_init($url);
curl_setopt($curl, CURLOPT_HEADER, false);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_HTTPHEADER,
        array(
          "Content-type: application/json",
          "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
        ));
curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "PUT");
curl_setopt($curl, CURLOPT_POSTFIELDS, $content);

$json_response = curl_exec($curl);
?>
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
const url = "https://api.datacue.co/v1/batch";
let data = {
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
// The parameters we are going to pass to the fetch function
let fetchData = {
    method: "PUT",
    body: data,
    headers: new Headers(
      "Content-Type", "application/json",
      "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
      )
}
fetch(url, fetchData)
.then((res) => res.json())
.then((data) =>  console.log(data))
.catch((err) => console.log(err))
```

> The above command returns a 207 multi status response code

We will send you a status for each item you sent, so you can handle and resend only items that had an error.

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

## Batch Delete Banners/ Products / Users or Cancel Orders

URL: `DELETE` `https://api.datacue.co/v1/batch`

Delete/cancel multiple items within one request. Products, banners and users will be deleted. Orders are an exception, 'DELETING' an order marks it as cancelled. Batch DELETE requests only require an id field as follows:

**Type**|**ID Field(s)**
:-----:|:-----:
banners|banner_id
orders|order_id
products|product_id and variant_id
users|user_id


```javascript--browser
//backend only event (refer to the python, php or node tab)
```

```php
<?
$url = "https://api.datacue.co/v1/batch";
$data = array(
  "type" => "users",
  "batch" => array(
    array("user_id" => "u1"),
    array("user_id" => "u2"),
    array("user_id" => "u3"),
  )
)

$content = json_encode($data);

$curl = curl_init($url);
curl_setopt($curl, CURLOPT_HEADER, false);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_HTTPHEADER,
        array(
          "Content-type: application/json",
          "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
        ));
curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "DELETE");
curl_setopt($curl, CURLOPT_POSTFIELDS, $content);

$json_response = curl_exec($curl);

?>
```

```python
import requests

url = "https://api.datacue.co/v1/batch
headers = {
  "Content-type": "application/json",
  "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
}
data = {
   "type": "users",
   "batch": [
     {
       "user_id":"u1"
     },
     {
       "user_id":"u2"
     },
     {
       "user_id":"u3"
     }
  ]
}

response = requests.delete(url, data=data, headers=headers)
```

```javascript--node
const url = "https://api.datacue.co/v1/batch";
let data = {
   "type": "users",
   "batch": [
     {
       "user_id":"u1"
     },
     {
       "user_id":"u2"
     },
     {
       "user_id":"u3"
     }
  ]
}
// The parameters we are going to pass to the fetch function
let fetchData = {
    method: "DELETE",
    body: data,
    headers: new Headers(
      "Content-Type", "application/json",
      "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
      )
}
fetch(url, fetchData)
.then((res) => res.json())
.then((data) =>  console.log(data))
.catch((err) => console.log(err))
```

> The above command returns a 207 multi status response code

We will send you a status for each item you sent, so you can handle and resend only items that had an error.

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
