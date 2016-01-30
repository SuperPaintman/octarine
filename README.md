# octarine

[![Linux Build][travis-image]][travis-url]
[![Windows Build][appveyor-image]][appveyor-url]
[![NPM version][npm-v-image]][npm-url]
[![NPM Downloads][npm-dm-image]][npm-url]
[![Test Coverage][coveralls-image]][coveralls-url]

[![Logo](/README/logo.png)][npm-url]

The actor model for Node.js


## Installation
```sh
npm install octarine --save
```

--------------------------------------------------------------------------------

## Usage

**Start coroutine from function**

```js
const co = require('co');
const go = require('octarine');

function fakeCoroutine(result) {
    return new Promise((resolve, reject) => {
        setTimeout(()=>{
            resolve(result);
        }, 300);
    });
}

co(function* () {
    // runs as new process
    const result = yield go(fakeCoroutine, ['Terry Pratchett']);

    console.log(result); // logs 'Terry Pratchett' after 3s.
}).catch((err) => {
    console.log(err.toString());
});
```

**of from own file**

`main.js`:

```js
/** main.js */
const co = require('co');
const go = require('octarine');

co(function* () {
    // runs as new process
    const result = yield go("./myCoroutine.js");

    console.log(result); // logs 'Terry Pratchett' after 3s.
}).catch((err) => {
    console.log(err.toString());
});
```

`myCoroutine.js`:

```js
/** myCoroutine.js */
const ack = require('octarine/ack');

ack('Terry Pratchett');
```

--------------------------------------------------------------------------------

## API
### octarine(fn, attr)
**Arguments**
* **fn** {`Function`} - function runs as a coroutine
* **args** {`Any[]`}  - arguments passed to the function

**Returns**
* {`Promise`}

**Example**

```js
const go = require('octarine');

go(() => {
    return "hello"; // Or any value, function, promise...
}).then((res) => {
    console.log(res); // "hello"
});
```


### octarine(path, attr)
**Arguments**
* **fn** {`Function`} - path to coroutine file
* **args** {`Any[]`}  - process arguments

**Returns**
* {`Promise`}

**Example**

`main.js`

```js
/** main.js */
const go = require('octarine');

go("myCoroutine.js").then((res) => {
    console.log(res); // "hello"
});
```

`myCoroutine.js`

```js
/** myCoroutine.js */
const ack = require('octarine/ack');

ack("hello");
```


### ack(result)
**Arguments**
* **result** {`Any`}

**Example**

```js
/** myCoroutine.js */
const ack = require('octarine/ack');

ack("hello");
```

--------------------------------------------------------------------------------

## Changelog
### 0.2.0 [`Unstable`]
```diff
+ Run coroutine from file
```

### 0.1.0 [`Unstable`]
```diff
+ First realise
```

--------------------------------------------------------------------------------

## License
Copyright (c)  2016 [Alexander Krivoshhekov][github-author-link]

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[github-author-link]: http://github.com/SuperPaintman
[npm-url]: https://www.npmjs.com/package/octarine
[npm-v-image]: https://img.shields.io/npm/v/octarine.svg
[npm-dm-image]: https://img.shields.io/npm/dm/octarine.svg
[travis-image]: https://img.shields.io/travis/SuperPaintman/octarine/master.svg?label=linux
[travis-url]: https://travis-ci.org/SuperPaintman/octarine
[appveyor-image]: https://img.shields.io/appveyor/ci/SuperPaintman/octarine/master.svg?label=windows
[appveyor-url]: https://ci.appveyor.com/project/SuperPaintman/octarine
[coveralls-image]: https://img.shields.io/coveralls/SuperPaintman/octarine/master.svg
[coveralls-url]: https://coveralls.io/r/SuperPaintman/octarine?branch=master
