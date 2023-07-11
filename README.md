# course_api_example

## Basic Requirements

1. POST /api/v1/users
    ```zsh
    curl -X POST http://localhost:3000/api/v1/users -H "Content-Type: application/json" -d '{ "name": "Martin Fowler", "email": "m@f"}'

    {"status":"success","data":{}}
    ```
    ```zsh
    curl -X POST http://localhost:3000/api/v1/users -H "Content-Type: application/json" -d '{ "name": "Martin Fowler", "email": "m@f"}'

    {"status":"failed","error":{"code":400,"message":"Bad Request: name 'Martin Fowler' is used. email 'm@f' is used"}}
    ```

    ```zsh
    curl -X POST http://localhost:3000/api/v1/users -H "Content-Type: application/json" -d '{ "name": "Sandi Metz", "email": "sd@mt"}'

    {"status":"failed","error":{"code":400,"message":"Bad Request: email format should match /^S@S$/"}}
    ```

1. GET 	/api/v1/users/:id
    ```zsh
    curl http://localhost:3000/api/v1/users/1

    {"status":"success","data":{"id":1,"name":"Martin Fowler","email":"m@f"}}
    ```
    ```zsh
    curl http://localhost:3000/api/v1/users/9999

    {"status":"failed","error":{"code":400,"message":"Bad Request: User not found"}}
    ```
1. GET 	/api/v1/users
    ```zsh
    curl "http://localhost:3000/api/v1/users?name=Martin+Fowler"

    {"status":"success","data":{"id":1,"name":"Martin Fowler","email":"m@f"}}
    ```
    ```zsh
    curl "http://localhost:3000/api/v1/users?name=Martin+Fowler&email=mt@f"

    {"status":"failed","error":{"code":400,"message":"Bad Request: email format should match /^S@S$/"}}
    ```
    ```zsh
    curl "http://localhost:3000/api/v1/users?name=Yukihiro+Matsumoto"

    {"status":"failed","error":{"code":400,"message":"Bad Request: User not found"}}
    ```
1. PUT 	/api/v1/users/:id
    ```zsh
    curl -X PUT http://localhost:3000/api/v1/users/1 -H "Content-Type: application/json" -d '{"name": "M Fowler"}'

    {"status":"success","data":{}}

    curl http://localhost:3000/api/v1/users/1

    {"status":"success","data":{"id":1,"name":"M Fowler","email":"m@f"}}
    ```
    ```zsh
    curl -X PUT http://localhost:3000/api/v1/users/9999 -H "Content-Type: application/json" -d '{"name": "M Fowler", "email": "m@fl"}'

    {"status":"failed","error":{"code":400,"message":"Bad Request: id user not found. name 'M Fowler' is used. email format should match /^S@S$/"}}
    ```
1. DELETE /api/v1/users/:id
    ```zsh
    curl -X DELETE http://localhost:3000/api/v1/users/1

    {"status":"success","data":{}}

    curl http://localhost:3000/api/v1/users/1

    {"status":"failed","error":{"code":400,"message":"Bad Request: User not found"}}
    ```
    ```zsh
    curl -X DELETE http://localhost:3000/api/v1/users/9999

    {"status":"failed","error":{"code":400,"message":"Bad Request: User not found"}}
    ```

## About RSpec
- 有挑選幾個相較複雜的商務邏輯，[撰寫測試](spec)，提供給團隊了解我寫測試的風格。

## About In-Memory Data Manipulation

- 由於這是一個簡單的小範例，僅用[一個 singleton pattern 的 class](lib/dataset/base.rb) 代表底層資料庫操作。
- 實做是完全 in-memory 的，在 development 環境中 rails s 啟動時會建立 default seeds，server 中止後不會留存任何資料。
- 在開發環境中修改程式碼後不會留存資料、也不會重新建立 default seeds；有先做一個提示訊息。如果還有時間，可以考慮設計更優雅的做法。

    ```zsh
    curl http://localhost:3000/api/v1/users/1

    {"status":"failed","error":{"code":400,"message":"Bad Request: Dataset is not set up. Please restart Rails app."}}
    ```
- 就算有做任何形式的 snapshot，或容許僅用於暫存資料，實務上，我個人還是非常不建議這種作法，如有興趣可再討論。
