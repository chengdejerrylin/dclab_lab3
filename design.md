# DCLab_Lab3

## Main module

### Top

* 處理使用者input
* 跟各個module說現在的state

###I2C

* 一開始給晶片reset
* busy訊號給Top

###DSP (珽)

* 跟SRAM要資料(data, sram的valid)\給資料(data)
* 跟Top要現在的state (含pause，play速度， 錄音超過)
* 錄音時跟LED說現在的音量大小
* 跟output module說 現在play的位置
* 處理快轉慢轉（一階內插/零階內插）
* 沒事丟0給I2S

### I2S

* 從DSP要資料，直接傳到晶片
* 跟晶片拿資料丟到SRAM
* 用busy跟DSP說傳輸完成

### SRAM

* 存I2S丟過來的訊號，給DSP訊號
* 紀錄錄音/播放到哪個addr
* 錄音超過32秒時跟Top說（overflow的時候不要繼續存）
* 播放到底也要跟Top到結束
* 跟output module說 現在record的位置
* **給SRAM的訊號都要是FF，讀SRAM先用一個reg擋著**

## Bonus Output module

### LED

* 音量大小

### LCD

* whatever I like

### SevenHexDecoder

* 播放/錄音位置

