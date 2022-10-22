package com.mind.base.service

interface ExplainDBService {
    fun queryAllFields(table: String): List<Map<String, Any>>
}