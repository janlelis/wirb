module Wirb
  module SchemaBuilder
     # Loads a color schema from a yaml file
     #   If first argument is a String: path to yaml file
     #   If first argument is a Symbol: bundled schema
     def self.load_schema_from_yaml(yaml_path = :classic)
       schema_name, schema_yaml = resolve_schema_yaml(yaml_path)
       raise LoadError, "Could not load the Wirb schema at: #{yaml_path}" unless schema_yaml.is_a?(Hash)

       schema = normalize_schema(schema_yaml)
       schema[:name] = schema_name.to_sym
       schema
     end

     def self.resolve_schema_yaml(yaml_path)
       if yaml_path.is_a? Symbol # bundled themes
         [yaml_path.to_s, YAML.load_file(File.join(Gem.datadir('wirb'), "#{yaml_path}.yml"))]
       else
         [File.basename(yaml_path).gsub(/\.yml$/, ''), YAML.load_file(yaml_path)]
       end
     end

     def self.normalize_schema(schema_yaml)
       normalized_schema = Hash[ schema_yaml.map{ |k,v| [k.to_s.to_sym, Array( v )] } ]
       %w(
         hash
         array
         set
         symbol_string
         string
         regexp
         rational
         complex
         object
       ).each{ |what|
         values = normalized_schema.delete(:"#{what}_delimiter")
         normalized_schema[:"open_#{what}"]  = values
         normalized_schema[:"close_#{what}"] = values
       }

       normalized_schema
     end
  end
end
