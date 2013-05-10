NXJSON
================================

Very small JSON parser written in C.

##Features

- Parse JSON from string
- Easy browsing API
- Unescape string values (except Unicode)
- Comments // line and /\* block \*/ skipped

##Limitations

- No Unicode support (\uXXXX escape sequences remain untouched)
- Might accept invalid JSON (eg., extra commas, comments), don't use for validation

##Example

JSON code:

    {
      "some-int": 195,
      "array": [ 3, 5.1, -7, "nine", /*11*/ ],
      "some-bool": true,
      "some-dbl": -1e-4,
      "some-null": null,
      "hello": "world!",
      //"other": "/OTHER/",
      "obj": {"KEY": "VAL"}
    }

C API:

    const nx_json* json=nx_json_parse(code);
    if (json) {
      printf("some-int=%ld\n", nx_json_get(json, "some-int")->int_value);
      printf("some-dbl=%lf\n", nx_json_get(json, "some-dbl")->dbl_value);
      printf("some-bool=%ld\n", nx_json_get(json, "some-bool")->int_value);
      printf("some-null=%s\n", nx_json_get(json, "some-null")->text_value);
      printf("hello=%s\n", nx_json_get(json, "hello")->text_value);
      printf("other=%s\n", nx_json_get(json, "other")->text_value);
      printf("KEY=%s\n", nx_json_get(nx_json_get(json, "obj"), "KEY")->text_value);
      const nx_json* arr=nx_json_get(json, "array");
      int i;
      for (i=0; i<arr->length; i++) {
        const nx_json* item=nx_json_item(arr, i);
        printf("arr[%d]=(%d) %ld %lf %s\n", i, (int)item->type, item->int_value, item->dbl_value, item->text_value);
      }
      nx_json_free(json);
    }

##License

LGPL v3

##Copyright

Copyright (c) 2013 Yaroslav Stavnichiy <yarosla@gmail.com>
