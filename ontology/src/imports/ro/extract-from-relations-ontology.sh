# Download the RO version from 2023-02-22
curl -L https://raw.githubusercontent.com/oborel/obo-relations/v2023-02-22/ro.owl > ro-full-download.owl
# Annotates all axioms with the source's version IRI if it exists, else with the ontology IRI (using prov:wasDerivedFrom) and overwrites the input with that change (https://github.com/OpenEnergyPlatform/ontology/issues/1179 was solved by this step)
# runs with ROBOT v1.91
robot annotate --input ro-full-download.owl --annotate-derived-from true --output ro-full-download.owl
# Extract the terms we want with hierarchy
robot merge --input ro-full-download.owl extract --method MIREOT --lower-terms ro-extract-w-hierarchy.txt --intermediates all --output ro-extracted.owl
## Extract the terms we want without hierarchy
#robot merge --input ro-full-download.owl extract --method MIREOT --lower-terms ro-extract-n-hierarchy.txt --upper-term owl:topObjectProperty --intermediates none --output ro-extracted-n-hierarchy.owl
# Create Extracted module
robot merge --input ro-extracted.owl annotate --annotation rdfs:comment "This file contains externally imported content from the Relations Ontology (RO) for MENO. It is automatically extracted using ROBOT." --output ro-extracted.owl
robot merge --input ro-extracted.owl annotate --ontology-iri https://raw.githubusercontent.com/stap-m/midlevel-energy-ontology/main/ontology/src/imports/ro/ro-extracted.owl --version-iri https://raw.githubusercontent.com/stap-m/midlevel-energy-ontology/dev/ontology/src/imports/ro/ro-extracted.owl --output ro-extracted.owl
# Remove inSubset axioms
#robot remove --input ro-extracted.owl --term oboInOwl:inSubset --output ro-extracted.owl
# Remove subclass axioms from BFO classes
#robot remove --input ro-extracted.owl --term BFO:0000002 --select "self descendants" --select "<http://purl.obolibrary.org/obo/BFO_*>"   --axioms subclass --signature true --exclude-term BFO:0000040 --preserve-structure false --output ro-extracted.owl
# Remove annotations from BFO classes
# This is kaputt, makes the annotations appear twice. 
# robot remove --input ../../ontology/imports/ro-extracted.owl --term BFO:0000002 --term BFO:0000004 --term BFO:0000040 --select "self"  --exclude-term RO:0002577 --exclude-term BFO:0000050 --axioms annotation --signature true --preserve-structure false --output ../../ontology/imports/ro-extracted.owl

rm ro-full-download.owl
rm ro-extracted-w-hierarchy.owl
#rm ro-extracted-n-hierarchy.owl
