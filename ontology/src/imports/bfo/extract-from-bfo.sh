# Download the RO version from 2023-02-22
curl -L https://raw.githubusercontent.com/BFO-ontology/BFO2/master/ontology/src/bfo.owl > bfo-full-download.owl
# Annotates all axioms with the source's version IRI if it exists, else with the ontology IRI (using prov:wasDerivedFrom) and overwrites the input with that change (https://github.com/OpenEnergyPlatform/ontology/issues/1179 was solved by this step)
# runs with ROBOT v1.91
robot annotate --input bfo-full-download.owl --annotate-derived-from true --output bfo-full-download.owl
# Extract the terms we want with hierarchy
robot merge --input bfo-full-download.owl extract --method MIREOT --lower-terms bfo-extract-w-hierarchy.txt --intermediates all --output bfo-extracted.owl
## Extract the terms we want without hierarchy
#robot merge --input ro-full-download.owl extract --method MIREOT --lower-terms ro-extract-n-hierarchy.txt --upper-term owl:topObjectProperty --intermediates none --output ro-extracted-n-hierarchy.owl
# Create Extracted module
robot merge --input bfo-extracted.owl annotate --annotation rdfs:comment "This file contains externally imported content from the Basic Formal Ontology (BFO). It is automatically extracted using ROBOT." --output bfo-extracted.owl
#robot merge --input ro-extracted-w-hierarchy.owl --input ro-extracted-n-hierarchy.owl annotate --ontology-iri http://openenergy-platform.org/ontology/oeo/imports/ro-extracted.owl --version-iri http://openenergy-platform.org/ontology/oeo/dev/imports/ro-extracted.owl --annotation rdfs:comment "This file contains externally imported content from the Relations Ontology (RO). It is automatically extracted using ROBOT." --output ../../ontology/imports/ro-extracted.owl
# Remove inSubset axioms
#robot remove --input ro-extracted.owl --term oboInOwl:inSubset --output ro-extracted.owl
# Remove subclass axioms from BFO classes
#robot remove --input ro-extracted.owl --term BFO:0000002 --select "self descendants" --select "<http://purl.obolibrary.org/obo/BFO_*>"   --axioms subclass --signature true --exclude-term BFO:0000040 --preserve-structure false --output ro-extracted.owl
# Remove annotations from BFO classes
# This is kaputt, makes the annotations appear twice. 
# robot remove --input ../../ontology/imports/ro-extracted.owl --term BFO:0000002 --term BFO:0000004 --term BFO:0000040 --select "self"  --exclude-term RO:0002577 --exclude-term BFO:0000050 --axioms annotation --signature true --preserve-structure false --output ../../ontology/imports/ro-extracted.owl

#rm bfo-full-download.owl
#rm bfo-extracted-w-hierarchy.owl
#rm ro-extracted-n-hierarchy.owl
