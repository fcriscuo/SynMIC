package org.batteryparkdev.synmic.model

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.channels.produce
import kotlinx.coroutines.delay
import kotlinx.coroutines.runBlocking
import org.apache.commons.csv.CSVRecord
import org.batteryparkdev.io.CSVRecordSupplier
import java.nio.file.Paths
import kotlin.streams.asSequence

/*
Responsible for validating the parsing of the SynMICdb.csv file to SynMutation data objects
 */

class TestSynMutation {


    private var nodeCount = 0

    @OptIn(ExperimentalCoroutinesApi::class)
    fun CoroutineScope.produceCSVRecords(filename: String) =
        produce<CSVRecord> {
            val path = Paths.get(filename)
            CSVRecordSupplier(path).get()
                .asSequence()
                .forEach {
                    send(it)
                    delay(20)
                }
        }

    fun testCosmicModel() = runBlocking {
        val filename = "./data/sample_SynMICdb.csv"
        val records = produceCSVRecords(filename)
        for (record in records) {
            nodeCount += 1
            val synMut = SynMutation.parseCSVRecord(record)
            println("Syn mutation gene name: ${synMut.geneName}  sample id ${synMut.sampleId}")
            println(" RegRNA: ${synMut.regRna}")
            println(" SpliceADF: ${synMut.spliceAidF}")
        }
        println("Syn mutation record count = $nodeCount")
    }
}

fun main() = TestSynMutation().testCosmicModel()