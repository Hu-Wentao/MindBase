package com.mind.base.service

import org.apache.poi.ss.usermodel.CellType
import org.apache.poi.ss.usermodel.WorkbookFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.stereotype.Service
import java.io.InputStream
import java.io.OutputStream

@Service
class TableExportServiceImpl : TableExportService {

    @Autowired
    private lateinit var jdbcTemplate: JdbcTemplate

    @Autowired
    private lateinit var explainDBService: ExplainDBService

    override fun importDB(rows: List<Map<String, String>>, table: String) {
        rows.forEach {col->
            val dbInsertSql = "INSERT INTO $table ${
                col.keys.joinToString(",", "(", ")")
            } VALUES ${
                col.values.joinToString(",", "(", ")") {
                    "\'$it\'"
                }
            }"
            jdbcTemplate.update(dbInsertSql)
        }
    }

    override fun importDB(excelStream: InputStream, table: String) {
        excelStream.use { input ->
            WorkbookFactory.create(input).forEach { sheet ->
                val colCount = sheet.getRow(0).count()
                val values = List(colCount) {
                    "?"
                }.joinToString(
                    ",",
                    "(",
                    ")"
                )
                //表头认为是db的列名
                val dbInsertSql = "INSERT INTO $table ${
                    sheet.getRow(0).joinToString(
                        ",",
                        "(",
                        ")"
                    )
                } VALUES $values"
                val insertList = mutableListOf<Array<Any?>>()
                sheet.forEachIndexed { index, row ->
                    if (index == 0) {
                        return@forEachIndexed
                    }
                    val insertData: Array<Any?> = row.fold(mutableListOf<Any?>()) { acc, col ->
                        when (col.cellType) {
                            CellType._NONE -> acc.add(null)
                            CellType.NUMERIC -> acc.add(col.numericCellValue.toString())
                            CellType.STRING -> acc.add(col.stringCellValue ?: null)
                            CellType.FORMULA -> acc.add(null)
                            CellType.BLANK -> acc.add(null)
                            CellType.BOOLEAN -> acc.add(col.booleanCellValue)
                            CellType.ERROR -> acc.add(null)
                            else -> acc.add(null)
                        }
                        return@fold acc
                    }.toTypedArray()
                    insertList.add(insertData)
                }
                jdbcTemplate.batchUpdate(dbInsertSql, insertList)
            }
        }
    }

    override fun exportDBToCSV(table: String): OutputStream {
        TODO("Not yet implemented")
    }

    override fun exportDBToList(table: String): List<Map<String, String>> {
        return explainDBService.queryAllFields(table).map {
            it.mapValues {
                it.toString()
            }
        }
    }
}