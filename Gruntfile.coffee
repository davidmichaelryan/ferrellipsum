module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    coffee:    
      build:           
        files: [
          expand: true
          cwd: 'public/coffee'
          src: ['*.coffee']
          dest: 'build/js'
          ext: '.js' 
        ]
    sass: 
      dist: 
        files: [
          expand: true
          cwd: 'public/sass'
          src: '*.scss'
          dest: 'build/css'
          ext: '.css'
        ]
    watch: 
      files: ['public/sass/*.scss', 'public/coffee/*.coffee']
      tasks: ['sass', 'coffee']

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['sass', 'coffee', 'watch']