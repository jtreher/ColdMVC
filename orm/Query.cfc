component {

	public any function init(required any DAO, required any model, required struct options) {

		variables.model = arguments.model;
		variables.dao = arguments.dao;
		variables.modelManager = arguments.dao.getModelManager();
		variables.entity = variables.modelManager.getName(arguments.model);
		variables.alias = variables.modelManager.getAlias(variables.entity);
		variables.aliases = {};
		addAlias(variables.alias, variables.entity);
		variables.parameters = {};
		variables.options = arguments.options;

		variables.query = {
			select = "select #variables.alias#",
			from = "from #variables.entity# as #variables.alias#",
			joins = [],
			where = [],
			groupBy = ""
		};

		variables.operators = variables.dao.getOperators();

		variables.operatorMap = {
			"eq" = "equal",
			"neq" = "notEqual",
			"gt" = "greaterThan",
			"lt" = "lessThan",
			"gte" = "greaterThanEquals",
			"lte" = "lessThanEquals"
		};

		return this;

	}

	public any function andWhere() {

		return buildWhere(arguments, "and");

	}

	public any function count(string string="") {

		var previousSelect = variables.query.select;
		var previousOptions = duplicate(variables.options);

		if (arguments.string == "") {
			arguments.string = variables.alias & ".id";
		}

		variables.query.select = "select count(#arguments.string#)";

		structDelete(variables.options, "max");
		structDelete(variables.options, "offset");
		structDelete(variables.options, "sort");
		structDelete(variables.options, "order");

		var result = get();

		variables.query.select = previousSelect;

		structAppend(variables.options, previousOptions);

		return result;

	}

	public any function get() {

		unique(true);

		return getResults();

	}

	public any function getHQL() {

		var hql = variables.query.select & " " & variables.query.from;

		if (arrayLen(variables.query.joins) > 0) {
			 hql = hql & " " & arrayToList(variables.query.joins, " ");
		}

		if (arrayLen(variables.query.where) > 0) {

			var where = trim(arrayToList(variables.query.where, " "));

			if (left(where, 4) == "and ") {
				where = replaceNoCase(where, "and ", "");

			} else if (left(where, 3) == "or ") {
				where = replaceNoCase(where, "or ", "");
			}

			hql = hql & " where " & where;
		}

		if (variables.query.groupBy != "") {
			 hql = hql & " group by " & variables.query.groupBy;
		}

		return trim(hql);

	}

	public struct function getOptions() {

		return variables.options;

	}

	public any function setOptions(required struct options) {

		structAppend(variables.options, arguments.options, true);

		return this;

	}

	public any function getResults() {

		var result = variables.dao.executeQuery(variables.model, getHQL(), variables.parameters, variables.options);

		if (structKeyExists(variables.options, "unique") && variables.options.unique && isNull(result)) {
			return variables.dao.new(variables.model);
		}

		return result;

	}

	public any function groupBy(required string value) {

		variables.query.groupBy = arguments.value;

		return this;

	}

	public any function innerJoin(required string property, string alias="") {

		return buildJoin(arguments.property, arguments.alias, "inner");

	}

	public any function join(required string property, string alias="") {

		return buildJoin(arguments.property, arguments.alias, "");

	}

	public any function leftJoin(required string property, string alias="") {

		return buildJoin(arguments.property, arguments.alias, "left");

	}

	public any function list(struct options) {

		if (!structKeyExists(arguments, "options")) {
			arguments.options = {};
		}

		structAppend(variables.options, arguments.options, true);

		unique(false);

		variables.dao.checkOptions(variables.model, variables.options);

		return getResults();

	}

	public any function max(required any value) {

		if (isNumeric(arguments.value)) {
			variables.options.max = arguments.value;
		} else {
			structDelete(variables.options, "max");
		}

		return this;

	}

	public any function offset(required any value) {

		if (isNumeric(arguments.value)) {
			variables.options.offset = arguments.value;
		} else {
			structDelete(variables.options, "offset");
		}

		return this;

	}

	public any function order(required string value) {

		variables.options.order = arguments.value;

		return this;

	}

	public any function orWhere() {

		return buildWhere(arguments, "or");

	}

	public any function select(required string string) {

		variables.query.select = "select " & arguments.string;

		return this;

	}

	public any function sort(required string value) {

		variables.options.sort = arguments.value;

		return this;

	}

	public any function unique(required boolean value) {

		variables.options.unique = arguments.value;

		return this;

	}

	public any function where() {

		return buildWhere(arguments, "and");

	}

	private any function addAlias(required string alias, required string entity) {

		variables.aliases[arguments.alias] = {
			alias = arguments.alias,
			entity = arguments.entity
		};

		return this;

	}

	private string function buildClause(required string property, required string operator, any value="", boolean parameter=true) {

		var propertyDef = cleanProperty(arguments.property);
		var operatorDef = getOperator(arguments.operator);

		if (operatorDef.value != "") {

			var binding = "";

			if (arguments.parameter) {

				binding = listLast(arguments.property, ".");

				if (hasParameter(binding)) {
					var counter = 2;
					while (hasParameter(binding & "_" & counter)) {
						counter++;
					}
					binding = binding & "_" & counter;
				}

			}

			var type = variables.dao.getJavaType(propertyDef.model, propertyDef.property);

			var bindString = ":" & binding;

			if (operator == "in" || operator == "notIn") {

				if (!isArray(arguments.value)) {
					var arguments.value = listToArray(arguments.value);
				}

				var array = [];
				var i = "";
				for (i = 1; i <= arrayLen(arguments.value); i++) {
					if (trim(arguments.value[i]) != "") {
						arrayAppend(array, trim(arguments.value[i]));
					}
				}

				if (arrayIsEmpty(array)) {
					if (operator == "in") {
						return "1 = 0";
					} else {
						return "1 = 1";
					}
				}

				bindString = "(" & bindString & ")";

				var val = variables.dao.toJavaArray(type, array);

			} else {

				var val = variables.dao.updateOperatorValue(arguments.value, type, operatorDef);

			}

			variables.parameters[binding] = val;

			return trim("lower(" & propertyDef.alias & ") " & operatorDef.operator & " " & bindString);

		} else {

			return trim(propertyDef.alias & " " & operatorDef.operator);

		}

	}

	private string function buildConjunction(required array clauses, required string type) {

		return " ( " & trim(arrayToList(arguments.clauses, " " & arguments.type & " ")) & " ) ";

	}

	private any function buildJoin(required string property, required string alias, required string type) {

		var propertyDef = cleanProperty(arguments.property);

		if (arguments.alias == "") {
			arguments.alias = listLast(arguments.property, ".");
		}

		var relationship = variables.dao.getRelationship(propertyDef.model, propertyDef.property);

		addAlias(arguments.alias, relationship.entity);

		var string = arguments.type & " join " & propertyDef.alias & " as " & arguments.alias;

		arrayAppend(variables.query.joins, trim(string));

		return this;

	}

	private any function buildWhere(required struct collection, required string type) {

		var i = "";
		var j = "";

		for (i = 1; i <= structCount(arguments.collection); i++) {

			var value = arguments.collection[i];

			// make sure we're always working with arrays of clauses
			if (isSimpleValue(value)) {
				value = [ value ];
			}

			for (j = 1; j <= arrayLen(value); j++) {

				var string = trim(value[j]);

				if (string != "") {
					arrayAppend(variables.query.where, arguments.type & " " & string);
				}

			}

		}

		return this;

	}

	private struct function cleanProperty(required string property) {

		if (!find(".", arguments.property)) {
			arguments.property = variables.alias & "." & arguments.property;
		}

		var result = {};

		var alias = getAlias(listFirst(arguments.property, "."));
		result.model = alias.entity;
		result.property = variables.modelManager.getProperty(alias.entity, listLast(arguments.property, "."));
		result.alias = alias.alias & "." & result.property;

		return result;

	}

	private struct function getAlias(required string alias) {

		return variables.aliases[arguments.alias];

	}

	private struct function getOperator(required string name) {

		if (structKeyExists(variables.operatorMap, arguments.name)) {
			return variables.operators[variables.operatorMap[arguments.name]];
		} else {
			return variables.operators[arguments.name];
		}

	}

	private boolean function hasParameter(required string parameter) {

		return structKeyExists(variables.parameters, arguments.parameter);

	}

	private boolean function isOperator(required string name) {

		return structKeyExists(variables.operatorMap, arguments.name) || structKeyExists(variables.operators, arguments.name);

	}

	public string function filter(required string property, required string operator, any value) {

		if (!structKeyExists(arguments, "value")) {
			arguments.value = arguments.operator;
			arguments.operator = "eq";
		}

		if (arguments.value != "") {
			return buildClause(arguments.property, arguments.operator, arguments.value, true);
		} else {
			return "";
		}

	}

	public any function onMissingMethod(required string missingMethodName, required struct missingMethodArguments) {

		if (arguments.missingMethodName == "and" || arguments.missingMethodName == "or") {

			if (!structIsEmpty(arguments.missingMethodArguments)) {

				if (isArray(arguments.missingMethodArguments[1])) {

					var clauses = arguments.missingMethodArguments[1];

				} else {

					var clauses = [];
					var i = "";

					// convert the unnamed arguments into a sorted array
					for (i = 1; i <= structCount(arguments.missingMethodArguments); i++) {
						arrayAppend(clauses, trim(arguments.missingMethodArguments[i]));
					}

				}

				return buildConjunction(clauses, arguments.missingMethodName);

			}

		}

		if (isOperator(arguments.missingMethodName)) {

			var property = arguments.missingMethodArguments[1];
			var operator = arguments.missingMethodName;
			var value = (structCount(arguments.missingMethodArguments) > 1) ? arguments.missingMethodArguments[2] : "";
			var binding = (structCount(arguments.missingMethodArguments) > 2) ? arguments.missingMethodArguments[3] : true;

			return buildClause(property, operator, value, binding);

		}

		throw(message="Invalid method: #arguments.missingMethodName#");

	}

}