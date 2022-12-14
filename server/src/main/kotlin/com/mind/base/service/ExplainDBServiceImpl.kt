package com.mind.base.service

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.stereotype.Service


@Service
class ExplainDBServiceImpl :ExplainDBService {

    @Autowired
    private lateinit var jdbcTemplate: JdbcTemplate

    override fun queryAllFields(table: String): List<Map<String, Any>> {
        return jdbcTemplate.queryForList("select * from $table")
    }
}