module.exports = {
   content: [
      // "./app/views/**/*.html.erb",
      // "./app/helpers/**/*.rb",
      // "./app/assets/stylesheets/**/*.css",
      // "./app/javascript/**/*.js",
   ],
   theme: {
      color: {
         purple: {
            10: "#4149D9",
            20: "#435AD9",
         }
      },
      extend: {
         backgroundImage: {
            'diagonal-stripes': 'repeating-linear-gradient(45deg, #4149D9, #4149D9 16px, #435AD9 16px, #435AD9 32px)',
         },
      },
   },
   plugins: [],
};
