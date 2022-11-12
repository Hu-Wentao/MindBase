package com.mind.base.service

import com.googlecode.aviator.AviatorEvaluator
import org.springframework.stereotype.Service

@Service
class ComputeServiceImpl : ComputeService {
    override fun compute(pattern: String, input: Map<String, Any>): String {
        return AviatorEvaluator.execute(pattern, mapOf("record" to input)).toString()
    }
}
