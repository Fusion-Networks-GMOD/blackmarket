function LShop:ApiTestResponse()
    print("Called API TEST>")
    _blackmarket_json_response = _blackmarket_json_response or ""
    // Temp Steamid64(means nothing yet!)
    http.Fetch("http://212.192.29.131:2017/blackmarket?steamid64=123" , function(b)
        _blackmarket_json_response = b
        print(b)
        --print(_blackmarket_json_response , "#1")
    end)
    --print(_blackmarket_json_response , "#2")
    return _blackmarket_json_response
end
LShop:ApiTestResponse()

