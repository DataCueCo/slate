---
title: API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - php
  - python
  - javascript

includes:
  - errors

search: true
---

# Introduction

Welcome to the DataCue API. This API documentation is to help get your e-commerce store setup to apply real time personalization to your website.

<<<<<<< HEAD
We have language bindings in Javascript, PHP, and Python! You can view code examples in the dark area to the right, and you can switch the programming language of the examples with the tabs in the top right.
=======
We have language bindings in Shell, Ruby, Python, and JavaScript! You can view code examples in the dark area to the right, and you can switch the programming language of the examples with the tabs in the top right.
>>>>>>> upstream/master

# Headers

## Authentication

> To authorize, use this code:

```php
<?
$encode = base64_encode("API-key:"); # only API key for events endpoint

$encode = base64_encode("API-key:API-secret"); # apikey:apisecret for all other endpoints

$auth = "Basic $encode";
?>
```

```python
import base64
# for events endpoint, use apikey:
auth = "Basic {}".format(base64.b64encode(b"API-key:").decode("ascii"))

# for other endpoints, use apikey:apisecret
auth = "Basic {}".format(base64.b64encode(b"API-key:API-secret").decode("ascii"))
```

```javascript
# for events endpoint, use apikey:
let auth = `Basic ${btoa("API-key:")}`;

# for other endpoints, use apikey:apisecret
let auth = `Basic ${btoa("API-key:APi-secret")}`;
```

> Make sure to replace `API-key` with your API key.
>
> Sample Headers

```
  "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
```

You will receive a API key and an API secret. Each end-point requires either just an API key or both key and secret to authenticate.
We use HTTP Basic Authentication, which is in the format `apikey:apisecret` that is base64 encoded and prepended with the string "Basic ".

For example if the end requires only an API Key:
Leave the api secret field empty.
Base64 encode "abc123:", no password after the colon, and the final result will be "YWJjMTIzOg==".

This is passed in the authorization header like so `Authorization: Basic YWJjMTIzOg==`.

For API endpoints requiring API key and secret, do the same as above, except in step 1 the api secret must be filled.

## Content-Type

You must set a content-type header to "application/json".
`Content-Type: application/json`

# Events

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

#### User

User Identification (one of the two is mandatory, we will take `user_id` if you send both)

-   `user_id` : the user_id of the user if he/she has logged in

-   `anonymous_id`: an automatically generated visitor id if the user has not logged in.

-   `profile`: any information you’ve collected about the user. For instance, if you run a fashion store and ask the user whether they want to see a men/women version of the store. Please add this information under the profile.

#### Event

-   `type`: a mandatory field: it can be "pageview", "viewcart", "search", "wishlist", "click", "order" or "login"

-   `subtype`: required depending on the event type. For instance, pageview, wishlist and click require a subtype.

#### Context

-   `ip`: the users IP. If you don’t specify one, we will store the IP sent from the request header.

-   `user_agent`: If you don’t specify one, we will store the user_agent from the request header.
    NOTE: This only applies if you are registering events from client side or frontend code running on a browser, typically in a single page application. If your store is rendered on the server for instance with PHP, you must specify these fields as the request IP and user_agent we receive will be from your server.

#### Timestamp

-   `timestamp`: An ISO-8601 date string in UTC time for when the event happened (OPTIONAL)
    If you don’t specify this, we will log the event at current UTC time. It is recommended to only specify this field if you are sending us any historical data.

## Home Page View

Request banner and product recommendations when a user visits your home page

```php
<?
$url = "https://api.datacue.co/v1/events";
$data = array(
  "user" => array(
    "user_id" =>  "019mr8mf4r",
    "anonymous_id" => "a1",
    "profile" =>  array(
  	  "sex" => "female",
  	  "location" => "Santiago",
      "dob" => "1980-01-23",
      "income" => "high",
      "occupation" => "engineer",
      "marital_status" => "married"
    )
  ),
  "event" => array(
  	"type" => "pageview",
    "subtype" => "home"
  ),
  "context" =>  array(
    "ip" => "24.5.68.47",
    "user-agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  ),
  "timestamp" => "2012-12-02T00 => 30 => 08.276Z"
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

url = "https://api.datacue.co/v1/events"
headers = {
  "Content-type": "application/json",
  "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
}
data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "a1",
    "profile": {
  	  "sex": "female",
  	  "location": "Santiago",
      "dob": "1980-01-23",
      "income": "high",
      "occupation": "engineer",
      "marital_status": "married"
    }
  },
  "event": {
  	"type": "pageview",
    "subtype": "home"
  },
  "context": {
    "ip": "24.5.68.47",
    "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  },
  "timestamp": "2012-12-02T00:30:08.276Z"
}


response = requests.post(url, json=data, headers=headers)
```

```javascript
const url = "https://api.datacue.co/v1/events";
let data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "a1",
    "profile": {
  	  "sex": "female",
  	  "location": "Santiago",
      "dob": "1980-01-23",
      "income": "high",
      "occupation": "engineer",
      "marital_status": "married"
    }
  },
  "event": {
  	"type": "pageview",
    "subtype": "home"
  },
  "context": {
    "ip": "24.5.68.47",
    "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  },
  "timestamp": "2012-12-02T00:30:08.276Z"
}
// The parameters we are gonna pass to the fetch function
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

> The above command returns JSON structured like this:

```json
{
  "main_banners": [
    {
      "banner_id": "B4",
      "photo_url": "/banners/living-room/livingroom-min.jpeg",
      "title": "Living Room",
      "link": "/category/living-room"
    },
  ],
  "sub_banners": [
    {
      "banner_id": "B16",
      "photo_url": "/banners/living-room/subbanner_lamps.jpeg",
      "title": "Lamps",
      "link": "/category/living-room/lamps"
    },
  ],
  "related_product_skus": [       
    {
      "product_id": "48",
      "variant_id": "1"
      "category_1": "kitchen",
      "category_2": "dining-table",
      "category_3": "scandinavian",
      "category_4": "modern",
      "name": "Modern Table",
      "link": "/table-1",
      "price": "219",
      "photo_url": "/products/48.jpg"
    }
  ]
}
```

## Product Page View

Request product recommendations when a user visits a product page

```php
<?
$url = "https://api.datacue.co/v1/events";
$data = array(
  "user" => array(
    "user_id" =>  "019mr8mf4r",
    "anonymous_id" => "a1",
    "profile" =>  array(
  	  "sex" => "female",
  	  "location" => "Santiago",
      "dob" => "1980-01-23",
      "income" => "high",
      "occupation" => "engineer",
      "marital_status" => "married"
    )
  ),
  "event" =>  array(
    "type" =>  "pageview",
    "subtype" =>  "product",
    "product_id" => "p1",
    "variant_id" => "v1"
  ),
  "context" =>  array(
    "ip" =>  "24.5.68.47",
    "user-agent" =>  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  ),
  "timestamp" =>  "2012-12-02T00 => 30 => 08.276Z"
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

url = "https://api.datacue.co/v1/events"
headers = {
  "Content-type": "application/json",
  "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
}
data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "a1",
    "profile": {
  	  "sex": "female",
  	  "location": "Santiago",
      "dob": "1980-01-23",
      "income": "high",
      "occupation": "engineer",
      "marital_status": "married"
    }
  },
  "event": {
    "type": "pageview",
    "subtype": "product",
    "product_id": "p1",
    "variant_id": "v1"
  },
  "context": {
    "ip": "24.5.68.47",
    "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  },
  "timestamp": "2012-12-02T00:30:08.276Z"
}


response = requests.post(url, json=data, headers=headers)
```

```javascript
const url = "https://api.datacue.co/v1/events";
let data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "a1",
    "profile": {
  	  "sex": "female",
  	  "location": "Santiago",
      "dob": "1980-01-23",
      "income": "high",
      "occupation": "engineer",
      "marital_status": "married"
    }
  },
  "event": {
  	"type": "pageview",
    "subtype": "product",
    "product_id": "p1",
    "variant_id": "v1"
  },
  "context": {
    "ip": "24.5.68.47",
    "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  },
  "timestamp": "2012-12-02T00:30:08.276Z"
}
// The parameters we are gonna pass to the fetch function
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

> The above command returns JSON structured like this:

```json
{
  "related_product_skus": [       
    {
      "product_id": "48",
      "variant_id":"1",
      "category_1": "kitchen",
      "category_2": "dining-table",
      "category_3": "scandinavian",
      "category_4": "modern",
      "name": "Modern Table",
      "link": "/table-1",
      "price": "219",
      "photo_url": "/products/48.jpg",
       "extras": {"discount":"10%"}
    }
  ],
  "similar_product_skus": [
    {
      "product_id": "37",
      "variant_id":"1",
      "category_1": "outdoors",
      "category_2": "sofa",
      "category_3": "scandinavian",
      "category_4": "modern",
      "name": "Outdoor Armchair",
      "link": "/outdoor-sofa-2",
      "price": "199",
      "photo_url": "/products/37.jpg",
      "extras": {"promotion":true}
    },
  ]
}
```

## Shopping Cart (View Cart, Add/Remove Item)

Record activity on a users shopping cart, typically when the cart is viewed, or an item is added or removed.

```php
<?
$url = "https://api.datacue.co/v1/events";
$data = array(
  "user" => array(
    "user_id" =>  "019mr8mf4r",
    "anonymous_id" => "a1",
    "profile" =>  array(
  	  "sex" => "female"
    )
  ),
  "event" =>  array(
    "type" => "viewcart",
	  "cart" => array("p1","p2","p3")
  ),
  "context" =>  array(
    "ip" =>  "24.5.68.47",
    "user-agent" =>  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  ),
  "timestamp" =>  "2012-12-02T00 => 30 => 08.276Z"
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

url = "https://api.datacue.co/v1/events"
headers = {
  "Content-type": "application/json",
  "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
}
data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "a1",
    "profile": {
  	  "sex": "female"
    }
  },
  "event": {
    "type": "viewcart",
    "cart": ["p1","p2","p3"]
  },
  "context": {
    "ip": "24.5.68.47",
    "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  },
  "timestamp": "2012-12-02T00:30:08.276Z"
}


response = requests.post(url, json=data, headers=headers)
```

```javascript
const url = "https://api.datacue.co/v1/events";
let data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "a1",
    "profile": {
  	  "sex": "female"
    }
  },
  "event": {
    "type": "viewcart",
    "cart": ["p1","p2","p3"]
  },
  "context": {
    "ip": "24.5.68.47",
    "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  },
  "timestamp": "2012-12-02T00:30:08.276Z"
}
// The parameters we are gonna pass to the fetch function
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

> The above command returns JSON structured like this:

```json
{
  "related_product_skus": [
    {
      "product_id": "37",
      "variant_id": "v1",
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

## Search Page View

Record when performs a search on your website

```php
<?
$url = "https://api.datacue.co/v1/events";
$data = array(
  "user" => array(
    "user_id" =>  "019mr8mf4r",
    "anonymous_id" => "a1",
    "profile" =>  array(
  	  "sex" => "female"
    )
  ),
  "event" =>  array(
    "type" => "search",
    "term" => "blue jeans"
  ),
  "context" =>  array(
    "ip" =>  "24.5.68.47",
    "user-agent" =>  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  ),
  "timestamp" =>  "2012-12-02T00 => 30 => 08.276Z"
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

url = "https://api.datacue.co/v1/events"
headers = {
  "Content-type": "application/json",
  "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
}
data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "a1",
    "profile": {
  	  "sex": "female"
    }
  },
  "event": {
    "type": "search",
    "term": "blue jeans"
  },
  "context": {
    "ip": "24.5.68.47",
    "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  },
  "timestamp": "2012-12-02T00:30:08.276Z"
}


response = requests.post(url, json=data, headers=headers)
```

```javascript
const url = "https://api.datacue.co/v1/events";
let data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "a1",
    "profile": {
  	  "sex": "female"
    }
  },
  "event": {
    "type": "search",
    "term": "blue jeans"
  },
  "context": {
    "ip": "24.5.68.47",
    "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  },
  "timestamp": "2012-12-02T00:30:08.276Z"
}
// The parameters we are gonna pass to the fetch function
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
## Update Wishlist

Record changes to users wishlist, typically when the wishlist is viewed, or a product is added or removed from the wishlist.

```php
<?
$url = "https://api.datacue.co/v1/events";
$data = array(
  "user" => array(
    "user_id" =>  "019mr8mf4r",
    "anonymous_id" => "a1",
    "profile" =>  array(
  	  "sex" => "female"
    )
  ),
  "event" =>  array(
    "type" => "wishlist",
    "wishlist" => array(
      array(
        "product_id" => "p1",
        "variant_id" => "v1"
      ),
      array(
        "product_id" => "p2",
        "variant_id" => "v2"
      )
    )
  ),
  "context" =>  array(
    "ip" =>  "24.5.68.47",
    "user-agent" =>  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  ),
  "timestamp" =>  "2012-12-02T00 => 30 => 08.276Z"
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

url = "https://api.datacue.co/v1/events"
headers = {
  "Content-type": "application/json",
  "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
}
data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "a1",
    "profile": {
  	  "sex": "female"
    }
  },
  "event": {
    "type": "wishlist",
    "wishlist": [
      {
        "product_id": "p1",
        "variant_id": "v1"
      },
      {
        "product_id": "p2",
        "variant_id": "v2"
      }
    ]
  },
  "context": {
    "ip": "24.5.68.47",
    "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  },
  "timestamp": "2012-12-02T00:30:08.276Z"
}


response = requests.post(url, json=data, headers=headers)
```

```javascript
const url = "https://api.datacue.co/v1/events";
let data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "a1",
    "profile": {
  	  "sex": "female"
    }
  },
  "event": {
    "type": "wishlist",
    "wishlist": [
      {
        "product_id": "p1",
        "variant_id": "v1"
      },
      {
        "product_id": "p2",
        "variant_id": "v2"
      }
    ]
  },
  "context": {
    "ip": "24.5.68.47",
    "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  },
  "timestamp": "2012-12-02T00:30:08.276Z"
}
// The parameters we are gonna pass to the fetch function
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

> The above command returns a 204 response code

## Banner Click

Record clicks to a banner or a sub banner, typically on your home page

```php
<?
$url = "https://api.datacue.co/v1/events";
$data = array(
  "user" => array(
    "user_id" =>  "019mr8mf4r",
    "anonymous_id" => "a1",
    "profile" =>  array(
  	  "sex" => "mujer"
    )
  ),
  "event" =>  array(
    "type" => "click",
    "subtype" => "banner",
    "banner_id" => "b1"
  ),
  "context" =>  array(
    "ip" =>  "24.5.68.47",
    "user-agent" =>  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  ),
  "timestamp" =>  "2012-12-02T00 => 30 => 08.276Z"
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

url = "https://api.datacue.co/v1/events"
headers = {
  "Content-type": "application/json",
  "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
}
data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "a1",
    "profile": {
  	  "sex": "mujer"
    }
  },
  "event": {
    "type": "click",
    "subtype": "banner",
    "banner_id": "b1"
  },
  "context": {
    "ip": "24.5.68.47",
    "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  },
  "timestamp": "2012-12-02T00:30:08.276Z"
}


response = requests.post(url, json=data, headers=headers)
```

```javascript
const url = "https://api.datacue.co/v1/events";
let data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "a1",
    "profile": {
  	  "sex": "mujer"
    }
  },
  "event": {
    "type": "click",
    "subtype": "banner",
    "banner_id": "b1"
  },
  "context": {
    "ip": "24.5.68.47",
    "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  },
  "timestamp": "2012-12-02T00:30:08.276Z"
}
// The parameters we are gonna pass to the fetch function
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

> The above command returns a 204 response code

## Product Click

Record clicks on a product anywhere on your website.

```php
<?
$url = "https://api.datacue.co/v1/events";
$data = array(
  "user" => array(
    "user_id" =>  "019mr8mf4r",
    "anonymous_id" => "a1",
    "profile" =>  array(
  	  "sex" => "mujer"
    )
  ),
  "event" =>  array(
    "type" => "click",
    "subtype" => "product",
    "product_id" => "p2"
  ),
  "context" =>  array(
    "ip" =>  "24.5.68.47",
    "user-agent" =>  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  ),
  "timestamp" =>  "2012-12-02T00 => 30 => 08.276Z"
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

url = "https://api.datacue.co/v1/events"
headers = {
  "Content-type": "application/json",
  "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
}
data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "a1",
    "profile": {
  	  "sex": "mujer"
    }
  },
  "event": {
    "type": "click",
    "subtype": "product",
    "product_id": "p2"
  },
  "context": {
    "ip": "24.5.68.47",
    "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  },
  "timestamp": "2012-12-02T00:30:08.276Z"
}


response = requests.post(url, json=data, headers=headers)
```

```javascript
const url = "https://api.datacue.co/v1/events";
let data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "a1",
    "profile": {
  	  "sex": "mujer"
    }
  },
  "event": {
    "type": "click",
    "subtype": "product",
    "product_id": "p2"
  },
  "context": {
    "ip": "24.5.68.47",
    "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  },
  "timestamp": "2012-12-02T00:30:08.276Z"
}
// The parameters we are gonna pass to the fetch function
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

> The above command returns a 204 response code

## Check Out (Start Order)

Record the moment the user initiates the check out process, typically from their shopping cart.

```php
<?
$url = "https://api.datacue.co/v1/events";
$data = array(
  "user" => array(
    "user_id" =>  "019mr8mf4r",
    "anonymous_id" => "a1",
    "profile" =>  array(
  	  "sex" => "female"
    )
  ),
  "event" =>  array(
    "type" => "order",
    "subtype" => "started",
    "order_id" => "o1",
    "cart" => array(
      array(
        "product_id" => "p1",
        "variant" => "v1",
        "quantity" => 1,
        "price" => 24,
        "currency" => "USD"
      )
    )
  ),
  "context" =>  array(
    "ip" =>  "24.5.68.47",
    "user-agent" =>  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  ),
  "timestamp" =>  "2012-12-02T00 => 30 => 08.276Z"
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

url = "https://api.datacue.co/v1/events"
headers = {
  "Content-type": "application/json",
  "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
}
data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "a1",
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
  },
  "context": {
    "ip": "24.5.68.47",
    "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  },
  "timestamp": "2012-12-02T00:30:08.276Z"
}


response = requests.post(url, json=data, headers=headers)
```

```javascript
const url = "https://api.datacue.co/v1/events";
let data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "a1",
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
  },
  "context": {
    "ip": "24.5.68.47",
    "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  },
  "timestamp": "2012-12-02T00:30:08.276Z"
}
// The parameters we are gonna pass to the fetch function
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

> The above command returns a 204 response code

## Complete Order

Record the moment the order (or checkout) is completed.

```php
<?
$url = "https://api.datacue.co/v1/events";
$data = array(
  "user" => array(
    "user_id" =>  "019mr8mf4r",
    "anonymous_id" => "a1",
    "profile" =>  array(
  	  "sex" => "female"
    )
  ),
  "event" =>  array(
    "type" => "order",
    "subtype" => "completed",
    "order_id" => "o1",
    "buyer_id" => "",
    "payment_method" => "",
    "cart" => array(
      array(
        "product_id" => "p1",
        "variant_id" => "v1",
        "quantity" => 1,
        "unit_price" => 24000,
        "currency" => "USD"
      )
    )
  ),
  "context" =>  array(
    "ip" =>  "24.5.68.47",
    "user-agent" =>  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  ),
  "timestamp" =>  "2012-12-02T00 => 30 => 08.276Z"
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

url = "https://api.datacue.co/v1/events"
headers = {
  "Content-type": "application/json",
  "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
}
data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "a1",
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
  },
  "context": {
    "ip": "24.5.68.47",
    "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  },
  "timestamp": "2012-12-02T00:30:08.276Z"
}


response = requests.post(url, json=data, headers=headers)
```

```javascript
const url = "https://api.datacue.co/v1/events";
let data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "a1",
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
  },
  "context": {
    "ip": "24.5.68.47",
    "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  },
  "timestamp": "2012-12-02T00:30:08.276Z"
}
// The parameters we are gonna pass to the fetch function
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

> The above command returns a 204 response code

## User Login

Record logins by a user on your website, if the user login is cached, you do not need to fire this event when the user returns.

```php
<?
$url = "https://api.datacue.co/v1/events";
$data = array(
  "user" => array(
    "user_id" =>  "019mr8mf4r",
    "anonymous_id" => "a1",
    "profile" =>  array(
  	  "sex" => "female"
    )
  ),
  "event" =>  array(
    "type" => "login"
  ),
  "context" =>  array(
    "ip" =>  "24.5.68.47",
    "user-agent" =>  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  ),
  "timestamp" =>  "2012-12-02T00 => 30 => 08.276Z"
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

url = "https://api.datacue.co/v1/events"
headers = {
  "Content-type": "application/json",
  "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
}
data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "a1",
    "profile": {
  	  "sex": "female"
    }
  },
  "event": {
    "type": "login"
  },
  "context": {
    "ip": "24.5.68.47",
    "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  },
  "timestamp": "2012-12-02T00:30:08.276Z"
}


response = requests.post(url, json=data, headers=headers)
```

```javascript
const url = "https://api.datacue.co/v1/events";
let data = {
  "user": {
    "user_id": "019mr8mf4r",
    "anonymous_id": "a1",
    "profile": {
  	  "sex": "female"
    }
  },
  "event": {
    "type": "login"
  },
  "context": {
    "ip": "24.5.68.47",
    "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
  },
  "timestamp": "2012-12-02T00:30:08.276Z"
}
// The parameters we are gonna pass to the fetch function
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

> The above command returns a 204 response code
