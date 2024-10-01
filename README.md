# Mod WASM

## How do I setup to use WASM on PHP.

1. Install `ea-apache24-mod-wasm`.
1. Then you need to download the version of PHP wasm runtime that you need from [WASM module release](https://github.com/vmware-labs/webassembly-language-runtimes/releases).
1. Place `.wasm` file in `/usr/local/apache2/wasm_modules`
1. Update your `.htaccess` as follows:

```
<IfModule wasm_module>
    <IfModule dir_module>
        DirectoryIndex index.php
    </IfModule>
    <Location /wasm>
        AddHandler wasm-handler .php
        WasmModule /usr/local/apache2/wasm_modules/php-wasm/php-cgi-8.2.6.wasm
        WasmDir    /tmp
        WasmEnv TMPDIR /tmp
        WasmMapDir / /
        WasmEnableCGI On
    </Location>
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
