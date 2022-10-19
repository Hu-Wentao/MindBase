package com.mind.base

import com.googlecode.aviator.AviatorEvaluator
import org.junit.jupiter.api.Test
import org.springframework.boot.test.context.SpringBootTest

@SpringBootTest(classes = [MindBaseApplication::class])
class MindBaseTests {

	@Test
	fun test() {
		val ret = AviatorEvaluator.execute("1*2+(3*4)/5")
		assert(ret is Long)

		val retDouble = AviatorEvaluator.execute("1*2+(3*4)/5.0")
		assert(retDouble is Double)

		val env = mapOf("record" to mapOf("fInt1" to 1,"fInt2" to 222))

		val retInt = AviatorEvaluator.execute("field(fInt1) + field(fInt2)",env)

		assert(223 == retInt)
	}

}
