# Mod WASM

## What is MOD_WASM?

[Apache Con Description](https://www.apachecon.com/acna2022/slides/01_Gonz%C3%A1lez_mod-wasm_Bringing_WebAssembly.pdf)

## How do I setup to use WASM on PHP.

1. Install `ea-apache24-mod-wasm`.
1. Then you need to download the version of the PHP `.wasm` runtime file that you need from [WASM runtime releases](https://github.com/vmware-labs/webassembly-language-runtimes/releases).
1. Place the downloaded `.wasm` file in an appropriate subdirectory of `/usr/local/apache2/wasm_modules`
   * e.g. `/usr/local/apache2/wasm_modules/php-wasm/php-cgi-8.2.6.wasm`
1. Update your `.htaccess` as follows:

```
<IfModule wasm_module>
    AddHandler wasm-handler .php
    WasmModule /usr/local/apache2/wasm_modules/php-wasm/php-cgi-8.2.6.wasm
    WasmDir    /tmp
    WasmEnv TMPDIR /tmp
    WasmMapDir / /
    WasmEnableCGI On
</IfModule>
```

Here is a way to test it:

```
<html>
<body>
<?php
print "<h1>Hello from WASM PHP!</h1>";
$date = getdate();
$message = "Today, ";
$message .= $date['weekday'] . ", ";
$message .= $date['year'] . "-";
$message .= $date['mon'] . "-";
$message .= $date['mday'];
$message .= ", at ";
$message .= $date['hours'] . ":";
$message .= $date['minutes'] . ":";
$message .= $date['seconds'];
$message .= " we greet you with this message!";
print $message;
print "<h1>Output from phpinfo():</h1>";
phpinfo();
?>
</body>
</html>
```

## Will EA4 ever provide WASM runtime packages?

That is the plan. The WASM folks are in the process of moving things around so once that settles we will revisit providing them.

What we provide also depends on what people need. So this patient approach will give us a chance to collect that sort of data to help ensure we implement what people need.
