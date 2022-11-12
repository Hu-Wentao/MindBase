package com.mind.base.db

data class AppWriteProperties @JvmOverloads constructor(
    var endpoint: String = "",
    var key: String = "",
    var selfSigned:Boolean = false,
    var project: String = ""
)