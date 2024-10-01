# Mod WASM

## How do I use a specific WASM runtime for my site?

* Install `ea-apache24-mod-wasm`.
* Then you need to download the version of PHP wasm module that you need.
* [WASM module release](https://github.com/vmware-labs/webassembly-language-runtimes/releases)
* Get the version of WASM for your version of PHP.
* place it here:
* `/usr/local/apache2/wasm_modules/php-wasm/php-cgi-8.2.6.wasm`
* change the version as appropriate for your PHP.
* Update your .htaccess as follows:

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