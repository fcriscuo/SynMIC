package org.batteryparkdev.synmic.neo4j

import com.google.common.flogger.FluentLogger
import org.batteryparkdev.genomicgraphcore.neo4j.service.Neo4jConnectionService


/*
A collection of Neo4j database constraint definitions in Cypher
These constraints should be defined prior to loading the database with
any initial data.
 */
val constraints by lazy {
    listOf<String>(
        "CREATE CONSTRAINT unique_syn_mut_key IF NOT EXISTS ON (s:SynonymousMutation) ASSERT s.key IS UNIQUE"
    )
}

val logger: FluentLogger = FluentLogger.forEnclosingClass();

fun defineConstraints() {
    constraints.forEach {
        Neo4jConnectionService.defineDatabaseConstraint(it)
        logger.atInfo().log("Constraint: $it  has been defined")
    }
}

// stand-alone invocation
fun main(){
    println("Define constraints for ${System.getenv("NEO4J_DATABASE")} database")
    defineConstraints()
}