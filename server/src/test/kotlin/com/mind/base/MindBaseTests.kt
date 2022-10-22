package com.mind.base

import com.googlecode.aviator.AviatorEvaluator
import com.mind.base.service.ComputeService
import com.mind.base.service.ExplainDBService
import com.mind.base.service.TableExportService
import org.apache.commons.lang3.RandomStringUtils
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.core.io.ResourceLoader
import java.io.FileOutputStream
import kotlin.random.Random

@SpringBootTest(classes = [MindBaseApplication::class])
class MindBaseTests {

    @Autowired
    private lateinit var explainDBService: ExplainDBService

    @Autowired
    private lateinit var tableExportService: TableExportService

    @Autowired
    private lateinit var resourceLoader: ResourceLoader

    @Autowired
    private lateinit var computeService: ComputeService

    @Test
    fun testCompile() {
        val ret = AviatorEvaluator.execute("1*2+(3*4)/5")
        assert(ret is Long)

        val retDouble = AviatorEvaluator.execute("1*2+(3*4)/5.0")
        assert(retDouble is Double)

        val env = mapOf("record" to mapOf("fInt1" to 1, "fInt2" to 222))

        val retInt = AviatorEvaluator.execute("field(fInt1) + field(fInt2)", env)

        assert(223 == retInt)
    }

    @Test
    fun testQueryDB() {
        val queryAllFields = explainDBService.queryAllFields("Student")
        assert(queryAllFields.isNotEmpty())
    }


    @Test
    fun testInsertDB() {
        val queryAllFields = explainDBService.queryAllFields("Student")
        assert(queryAllFields.isNotEmpty())
    }

    @Test
    fun testInsertDBFromXls() {

        tableExportService.importDB(resourceLoader.getResource("classpath:user.xlsx").inputStream, "Student")
    }

    @Test
    fun testInsertDBFromList() {
        (1..100).map {
            mapOf(
                "name" to RandomStringUtils.random(Random.nextInt(2, 10), 0x4e00, 0x9fa5, false, false),
                "age" to Random.nextInt(0, 100).toString()
            )
        }.also {
            tableExportService.importDB(it, "Student")
        }
    }

    @Test
    fun testExportToExcel() {
        tableExportService.exportDBToCSV("Student", FileOutputStream("export.xlsx"))
    }

    @Test
    fun testCombine() {
        val ret = computeService.compute(
            "combine(combine(field(a),field(b)),field(c))",
            mapOf("a" to "aaa", "b" to "bbb", "c" to "ccc123")
        )
        assert(ret == "aaabbbccc123")
    }
}
