<?php

function httpError($response, $message, $code = 500) {
    http_response_code($code);
    echo json_encode(["error" => $message]);
    exit();
}
