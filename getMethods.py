import json
import tree_sitter
from tree_sitter import Language


JAVA_LANGUAGE = Language('../../parser2/my-languages.so', 'java')

# Initialize the parser
parser = tree_sitter.Parser()
parser.set_language(JAVA_LANGUAGE)

# Sample Java code
java_code = """

	public void applyDependencies(DependencyCustomizer dependencies) {
		dependencies.ifAnyMissingClasses(
				"org.springframework.bootstrap.SpringApplication").add(
				"org.springframework.bootstrap", "spring-bootstrap", "0.0.1-SNAPSHOT");
		dependencies.ifAnyResourcesPresent("logback.xml").add("ch.qos.logback",
				"logback-classic", "1.0.7");
		dependencies.ifNotAdded("cg.qos.logback", "logback-classic")
				.ifAnyResourcesPresent("log4j.properties", "log4j.xml")
				.add("org.slf4j", "slf4j-log4j12", "1.7.1")
				.add("log4j", "log4j", "1.2.16");
		dependencies.ifNotAdded("ch.qos.logback", "logback-classic")
				.ifNotAdded("org.slf4j", "slf4j-log4j12")
				.add("org.slf4j", "slf4j-jdk14", "1.7.1");
		// FIXME get the version
	}

"""
with open("prev.tmp.java") as f:
    prevf = f.read()
with open("next.tmp.java") as f:
    nextf = f.read()

# Parse the Java code

def extract_methods(node, methods):
    if node.type == 'method_declaration':
        method_name = None
        method_body = None
        for child in node.children:
            if child.type == 'identifier':
                method_name = child.text
            elif child.type == 'block':
                method_body = child.text.strip()
            elif child.type == 'formal_parameters':
                method_params = child.text.strip()
        if method_name and method_body:
            methods.append({'name': (method_name).decode("utf-8"), 'body': (method_body).decode("utf-8"), 'params': (method_params).decode("utf-8"), 'node': (node.text).decode("utf-8").replace("\n", " ")})
    for child in node.children:
        extract_methods(child, methods)

prevtree = parser.parse(bytes(prevf, "utf8"))
nexttree = parser.parse(bytes(nextf, "utf8"))

prevmethods = []
nextmethods = []
# Start extraction from the root node
extract_methods(prevtree.root_node, prevmethods)
extract_methods(nexttree.root_node, nextmethods)

for i in range(len(prevmethods)):
    for j in range(len(prevmethods)):
        if i != j and prevmethods[i]['name'] == prevmethods[j]['name'] and prevmethods[i]['params'] == prevmethods[j]['params']:
            with open("out.tmp.buggy", "w") as text_file:
                text_file.write("")
            with open("out.tmp.fixed", "w") as text_file:
                text_file.write("")
            exit()

for i in range(len(nextmethods)):
    for j in range(len(nextmethods)):
        if i != j and nextmethods[i]['name'] == nextmethods[j]['name'] and nextmethods[i]['params'] == nextmethods[j]['params']:
            with open("out.tmp.buggy", "w") as text_file:
                text_file.write("")
            with open("out.tmp.fixed", "w") as text_file:
                text_file.write("")
            exit()

maxfunclength = 2000
buggy = ""
fixed = ""
for i in range(len(prevmethods)):
    for j in range(len(nextmethods)):
        if prevmethods[i]['name'] == nextmethods[j]['name'] and prevmethods[i]['params'] == nextmethods[j]['params'] and prevmethods[i]['body'] != nextmethods[j]['body'] and len(nextmethods[j]['body']) < maxfunclength and len(prevmethods[i]['body']) < maxfunclength:
            buggy += prevmethods[i]['node'] + "\n"
            fixed += nextmethods[j]['node'] + "\n"

with open("out.tmp.buggy", "w") as text_file:
    text_file.write(buggy)

with open("out.tmp.fixed", "w") as text_file:
    text_file.write(fixed)
