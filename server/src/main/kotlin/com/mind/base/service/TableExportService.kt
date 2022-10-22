package com.mind.base.service;

import java.io.InputStream
import java.io.OutputStream

interface TableExportService {
    fun importDB(rows: List<Map<String, String>>, table: String)
    fun importDB(excelStream: InputStream, table: String)

    fun exportDBToCSV(table: String,os:OutputStream)
    fun exportDBToList(table: String): List<Map<String, String>>
}
