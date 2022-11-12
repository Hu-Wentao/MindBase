package com.mind.base.controller

import com.mind.base.ro.DBNameRO
import com.mind.base.service.TableExportService
import com.mind.base.vo.CommonVO
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.multipart.MultipartFile
import javax.servlet.http.HttpServletResponse

@RestController
@RequestMapping("/mindbase")
open class DataExportController {

    @Autowired
    private lateinit var tableExportService: TableExportService

    @RequestMapping("/importByExcel")
    fun importByExcel(@RequestParam("file") file: MultipartFile,@RequestParam("table")  tableName:String): CommonVO<Nothing> {
        tableExportService.importDB(file.inputStream, tableName)
        return CommonVO.success()
    }

    @RequestMapping("/exportToExcel")
    fun exportToExcel(@RequestBody dbNameRO: DBNameRO, servletResponse: HttpServletResponse) {
        servletResponse.contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        tableExportService.exportDBToCSV(dbNameRO.dbName,servletResponse.outputStream)
    }
}