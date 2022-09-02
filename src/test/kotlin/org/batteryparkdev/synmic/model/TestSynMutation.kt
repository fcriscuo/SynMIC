package org.batteryparkdev.synmic.model

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.channels.ReceiveChannel
import kotlinx.coroutines.channels.produce
import kotlinx.coroutines.delay
import kotlinx.coroutines.runBlocking
import org.apache.commons.csv.CSVRecord
import org.batteryparkdev.genomicgraphcore.common.io.CSVRecordSupplier
import java.nio.file.Paths
import kotlin.streams.asSequence

/*
Responsible for validating the parsing of the SynMICdb.csv file to SynMutation data objects
 */

class TestSynMutation {

    private var nodeCount = 0
    private var keySet = mutableSetOf<String>()
    private var hashSet = mutableSetOf<Int>()

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
    @OptIn(ExperimentalCoroutinesApi::class)
    fun CoroutineScope.filterDuplicates(records: ReceiveChannel<CSVRecord>) =
        produce<CSVRecord> {
            for (record in records) {
                val key = record.toString().hashCode()
                if(hashSet.contains(key).not()){
                    hashSet.add(key)
                    send(record)
                } else {
                    println("Duplicate record at node count: $nodeCount")
                }
            }
        }

    fun testCosmicModel() = runBlocking {
        val filename = "./data/sample_SynMICdb.csv"
        val records = filterDuplicates(produceCSVRecords(filename))
        for (record in records) {
            nodeCount += 1
            val synMut = SynMutation.parseCsvRecord(record)
            // generate Cypher code for a limited number of SynMut objects
            if (nodeCount <= 50){
                println("${synMut.generateLoadModelCypher()}\n\n")
            }
           // println("**** Syn mutation gene name: ${synMut.geneName}  sample id ${synMut.sampleId}")
          //  println("  chromosome: ${synMut.chromosome}  start: ${synMut.mutationStart} " +
            //        " end: ${synMut.mutationEnd}  strand: ${synMut.strand}")
//            if( synMut.regRna.isValid()){
//                println(" RegRNA: ${synMut.regRna}")
//            }
//            if (synMut.spliceAidF.isValid()){
//                println(" SpliceADF: ${synMut.spliceAidF}")
//            }
           // testUniqueness(synMut)
        }
        println("Syn mutation record count = $nodeCount")
        println("Hash set size = ${hashSet.size}")
    }
    /*
    Private function to determine if a combination of properties
    represent a unique identifier for this class
     */
    private fun testUniqueness(synMut: SynMutation) {
        val key = synMut.mutationId.plus(":").plus(synMut.sampleId)
        if(!keySet.contains(key)) {
            keySet.add(key)
        } else {
            println("ERROR: key: $key is not unique")
        }
    }
}

fun main() = TestSynMutation().testCosmicModel()