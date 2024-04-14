#!/bin/sh

name=%s
path=%s
path=$path"/"$name
shift
shift
echo "creating new express API project..."
mkdir $path
cd $path
npm init -y
[ -e index.js ] && rm index.js
[ -e router.js ] && rm router.js
[ -e services.js ] && rm services.js
[ -e .env ] && rm .env
#Create index
echo "const express = require('express');
const router = require('./router');
require('dotenv').config();
const app = express();
const PORT = process.env.PORT || 8080;

app.use(express.json());
app.use(router);
app.listen(PORT, () => {
    console.log('APP LISTENING ON PORT 8080');
});" >> index.js
#Create router
echo "const express = require('express');
const services = require('./services');
// Create Router
const router = express.Router();

//Basic Test Route
router.get('/', (req, res) => {
  services.helloService(req, res);
});

//Authors
router.get('/authors', async (req, res) => {
  try {
    await services.getAuthors(req, res);
  } catch (err) {
    console.error(err);
    res.sendStatus(500);
  }
});

router.get('/authors/:id', async (req, res) => {
  try {
    await services.getSingleAuthor(req, res);
  } catch (err) {
    console.error(err);
    res.sendStatus(500);
  }
});

router.post('/authors', async (req, res) => {
  try {
    await services.createAuthor(req, res);
  } catch (err) {
    console.error(err);
    res.sendStatus(500);
  }
});

router.delete('/authors/:id', async (req, res) => {
  try {
    await services.deleteAuthor(req, res);
  } catch (err) {
    console.error(err);
    res.sendStatus(500);
  }
});

router.patch('/authors/:id', async (req, res) => {
  try {
    await services.updateAuthor(req, res);
  } catch (err) {
    console.error(err);
    res.sendStatus(500);
  }
});

//Quotes
router.get('/quotes', async (req, res) => {
  try {
    await services.getQuotes(req, res);
  } catch (err) {
    console.error(err);
    res.sendStatus(500);
  }
});

router.get('/quotes/:id', async (req, res) => {
  try {
    await services.getSingleQuote(req, res);
  } catch (err) {
    console.error(err);
    res.sendStatus(500);
  }
});

router.post('/quotes', async (req, res) => {
  try {
    await services.createQuote(req, res);
  } catch (err) {
    console.error(err);
    res.sendStatus(500);
  }
});

router.delete('/quotes/:id', async (req, res) => {
  try {
    await services.deleteQuote(req, res);
  } catch (err) {
    console.error(err);
    res.sendStatus(500);
  }
});

router.patch('/quotes/:id', async (req, res) => {
  try {
    await services.updateQuote(req, res);
  } catch (err) {
    console.error(err);
    res.sendStatus(500);
  }
});

module.exports = router;" >>router.js
#Create services
echo "const db = require('./db/knexfile.js');

module.exports = {
  helloService: (req, res) => {
    res.status(200).json({
      message: 'I will build an awesome API!'
    });
  },

  getAuthors: async (req, res) => {
    try {
      const authors = await db('authors').select('*');
      res.status(200).json(authors);
    } catch (e) {
      res.status(500).json({
        error: e
      });
    }
  },

  getSingleAuthor: async (req, res) => {
    try {
      const id = req.params.id;
      const author = await db('authors').select('*').where('id', id).first();
      if (author) {
        res.status(200).json(author);
      } else {
        res.status(404).json({
          message: 'Author not found',
        });
      }
    } catch (e) {
      res.status(500).json({
        error: e
      });
    }
  },

  createAuthor: async (req, res) => {
    try {
      const author = req.body;
      await db('authors').insert(author);
      res.status(201).json({
        message: 'Author created',
        author: author.name.concat(' ', author.last_name)
      });
    } catch (e) {
      res.status(500).json({ error: e });
    }
  },

  deleteAuthor: async (req, res) => {
    try{
      const id = req.params.id;
      author = await db('authors').select('*').where('id', id).first();
      if(author){
        await db('authors').where('id', id).del();
        res.status(202).json({
          message: 'Author deleted',
          author: author
        });
      }else{
        res.status(404).json({
          message: 'Author not found'
        });
      }
    }catch(e){
      res.status(500).json({error: e});
    }
  },

  updateAuthor: async (req, res) => {
    try {
      const {name, last_name, nationality, occupation} = req.body;
      const id = req.params.id;
      const updateQuery = [];
      name && (updateQuery.name = name);
      last_name && (updateQuery.last_name = last_name);
      nationality && (updateQuery.nationality = nationality);
      occupation && (updateQuery.occupation = occupation);
      await db('authors')
      .where('id', id)
      .update(updateQuery);
      
      const author = await db('authors').select('*').where('id', id).first();
      if(author){
        res.status(200).json({ 
          message: 'Author updated successfully',
          author: author.name.concat(' ', author.last_name)
        });
      }else{
        res.status(404).json({
          message: 'Author not found'
        }); 
      }
    } catch (err) {
      console.error(err);
      res.status(500).json({
        error: err
      });
    }
  },

  getQuotes: async (req, res) => {
    try {
      const quotes = await db('quotes')
        .join('authors', 'quotes.author', 'authors.id')
        .select(
          'quotes.id as id',
         'quotes.quote as quote',
         db.raw(\"CONCAT(authors.name, ' ', authors.last_name) as author\"));
      res.status(200).json(quotes);
    } catch (e) {
      res.status(500).json({
        message: e
      });
    }
  },

  getSingleQuote: async (req, res) => {
    try {
      const id = req.params.id;
      const quote = await db('quotes')
        .join('authors', 'quotes.author', 'authors.id')
        .select(
          'quotes.id as id', 
          'quotes.quote as quote',
          db.raw(\"CONCAT(authors.name, ' ', authors.last_name) as author\")
        )
        .where('quotes.id', id)
        .first();
      if (quote) {
        res.status(200).json(quote);
      } else {
        res.status(404).json({
          message: 'Quote not found',
        });
      }
    } catch (e) {
      res.status(500).json({
        error: e
      });
    }
  },
  createQuote: async (req, res) => {
    try {
      const quote = req.body;
      await db('quotes').insert(quote);
      res.status(201).json({
        message: 'Quote created',
        quote: quote
      });
    } catch (e) {
      res.status(500).json({ error: e });
    }
  },
  deleteQuote: async (req, res) => {
    try{
      const id = req.params.id;
      quote = await db('quotes').select('*').where('id', id).first();
      if(quote){
        await db('quotes').where('id', id).del();
        res.status(202).json({
          message: 'Quote deleted',
          quote: quote
        });
      }else{
        res.status(404).json({
          message: 'Quote not found'
        });
      }
    }catch(e){
      res.status(500).json({error: e});
    }
  },
  updateQuote: async (req, res) => {
    try {
      const {quote, author} = req.body;
      const id = req.params.id;
      const updateQuery = [];
      quote && (updateQuery.quote = quote);
      author && (updateQuery.author = author);

      await db('quotes')
      .where('id', id)
      .update(updateQuery);
      
      const updatedQuote = await db('quotes').select('*').where('id', id).first();
      if(updatedQuote){
        res.status(200).json({ 
          message: 'Quote updated successfully',
          quote: updatedQuote
        });
      }else{
        res.status(404).json({
          message: 'Quote not found'
        }); 
      }
    } catch (err) {
      console.error(err);
      res.status(500).json({
        message: err
      });
    }
  },
}" >>services.js
echo "PORT=8080
DB_FILE=db/db.sqlite3" >>.env
rm package.json
echo '{
      "name":"'$name'",
      "version": "1.0.0",
      "description": "",
      "main": "index.js",
      "scripts": {
        "start": "node index.js",
        "start:dev": "nodemon index.js"
      },
      "keywords": [],
      "author": "",
      "license": "ISC",
      "dependencies": {
      }
    }' >>package.json
[ -d db ] && rm -rf db
mkdir db
#Create DB Creation Script
echo "const db = require('./knexfile');
const fs = require('fs')

const run = async () => {
    const quoteFile = fs.readFileSync('db/quotes.json');
    const parsedQuotes = JSON.parse(quoteFile);
    const [authors, quotes] = [parsedQuotes.authors, parsedQuotes.quotes];

    try {
        await db.schema.createTable('quotes', (table) => {
            table.increments('id');
            table.string('quote');
            table.integer('author');
        })
            .createTable('authors', (table) => {
                table.increments('id');
                table.string('name');
                table.string('last_name');
                table.string('nationality');
                table.string('occupation');
            });

        
        await db('quotes').insert(quotes);
        await db('authors').insert(authors);
    } catch (err) {
        console.log('ERROR ->', err)
    }finally{
        db.destroy();
    }
}

run()
">>db/create-db.js
#Create knexfile
echo "const knex = require('knex');
require('dotenv').config();

const db = knex({
    client:'sqlite3',
    connection: {
        filename:process.env.DB_FILE
    },
    useNullAsDefault: true
});

module.exports = db;">>db/knexfile.js
#Create quotes file
echo '{
    "authors": [
        {
            "name":"Albert",
            "last_name":"Einstein",
            "nationality":"German",
            "occupation":"Physicist"
        },
        {
            "name":"Joanne Kathleen",
            "last_name":"Rowling",
            "nationality":"British",
            "occupation":"Author"
        },
        {
            "name":"Mark",
            "last_name":"Twain",
            "nationality":"American",
            "occupation":"Writer" 
        },
        {
            "name":"Jane",
            "last_name":"Austin",
            "nationality":"British",
            "occupation":"Novelist" 
        },
        {
            "name":"Ralph Waldo",
            "last_name":"Emerson",
            "nationality":"American",
            "occupation":"Essayist" 
        },
        {
            "name":"Maya",
            "last_name":"Angelou",
            "nationality":"American",
            "occupation":"Poet" 
        },
        {
            "name":"Christopher",
            "last_name":"Columbus",
            "nationality":"Italian",
            "occupation":"Explorer" 
        },
        {
            "name":"Elie",
            "last_name":"Wiesel",
            "nationality":"Romanian",
            "occupation":"Writer" 
        },
        {
            "name":"Albus Percival Wulfric Brian",
            "last_name":"Dumbledore",
            "nationality":"British",
            "occupation":"Hogwarts Headmaster" 
        },
        {
            "name":"Leo",
            "last_name":"Tolstoy",
            "nationality":"Russian",
            "occupation":"Writer" 
        },
        {
            "name":"André",
            "last_name":"Gide",
            "nationality":"French",
            "occupation":"Author" 
        },
        {
            "name":"Steve",
            "last_name":"Jobs",
            "nationality":"American",
            "occupation":"Entrepreneur" 
        },
        {
            "name":"Ernest",
            "last_name":"Hemingway",
            "nationality":"American",
            "occupation":"Writer" 
        },
        {
            "name":"Mary",
            "last_name":"Shelley",
            "nationality":"British",
            "occupation":"Writer" 
        },
        {
            "name":"Edward Estlin",
            "last_name":"Cummings",
            "nationality":"American",
            "occupation":"Poet" 
        },
        {
            "name":"Henry David",
            "last_name":"Thoreau",
            "nationality":"American",
            "occupation":"Philosopher"
        },
        {
            "name":"Allen",
            "last_name":"Saunders",
            "nationality":"American",
            "occupation":"Writer"
        },
        {
            "name":"Edmund",
            "last_name":"Burke",
            "nationality":"Irish",
            "occupation":"Statesman"
        },
        {
            "name":"Nelson",
            "last_name":"Mandela",
            "nationality":"South African",
            "occupation":"Activist"
        },
        {
            "name":"Lao",
            "last_name":"Tzu",
            "nationality":"Chinese",
            "occupation":"Philosopher"
        },
        {
            "name":"Alan",
            "last_name":"Kay",
            "nationality":"American",
            "occupation":"Computer Scientist"
        },
        {
            "name":"Socrates",
            "last_name":"",
            "nationality":"Greek",
            "occupation":"Philosopher"
        },
        {
            "name":"Franklin Delano",
            "last_name":"Roosevelt",
            "nationality":"American",
            "occupation":"President"
        },
        {
            "name":"Abraham",
            "last_name":"Lincoln",
            "nationality":"American",
            "occupation":"President"
        },
        {
            "name":"Stephen",
            "last_name":"Covey",
            "nationality":"American",
            "occupation":"Author"
        },
        {
            "name":"Siddhartha",
            "last_name":"Gautama (Buddha)",
            "nationality":"Indian",
            "occupation":"Philosopher"
        },
        {
            "name":"Theodore",
            "last_name":"Roosevelt",
            "nationality":"American",
            "occupation":"President"
        },
        {
            "name":"Oscar",
            "last_name":"Wilde",
            "nationality":"Irish",
            "occupation":"Writer"
        },
        {
            "name":"Eleanor",
            "last_name":"Roosevelt",
            "nationality":"American",
            "occupation":"First Lady"
        },
        {
            "name":"Vince",
            "last_name":"Lombardi",
            "nationality":"American",
            "occupation":"Coach"
        },
        {
            "name":"Mahatma",
            "last_name":"Ghandi",
            "nationality":"Indian",
            "occupation":"Activist"
        },
        {
            "name":"Martin",
            "last_name":"Luther King",
            "nationality":"American",
            "occupation":"Activist"
        },
        {
            "name":"Robert",
            "last_name":"Frost",
            "nationality":"American",
            "occupation":"Poet"
        },
        {
            "name":"Robert Louis",
            "last_name":"Stevenson",
            "nationality":"Scottish",
            "occupation":"Poet"
        }
    ],
    "quotes": [
        {
            "quote":"Imagination is more important than knowledge.",
            "author":1
        },
        {
            "quote":"If you want to know what a man is like, take a good look at how he treats his inferiors, not his equals.",
            "author":2
        },
        {
            "quote":"The secret of getting ahead is getting started.",
            "author":3
        },
        {
            "quote":"It is a truth universally acknowledged, that a single man in possession of a good fortune, must be in want of a wife.",
            "author":4
        },
        {
            "quote":"To be yourself in a world that is constantly trying to make you something else is the greatest accomplishment.",
            "author":5
        },
        {
            "quote":"Two things are infinite: the universe and human stupidity; and I am not sure about the universe.",
            "author":1
        },
        {
            "quote":"I have learned that people will forget what you said, people will forget what you did, but people will never forget how you made them feel.",
            "author":6
        },
        {
            "quote":"Twenty years from now you will be more disappointed by the things that you did not do than by the ones you did do.",
            "author":3
        },
        {
            "quote":"You can never cross the ocean until you have the courage to lose sight of the shore.",
            "author":7
        },
        {
            "quote":"The opposite of love is not hate, it is indifference.",
            "author":8
        },{
            "quote":"It is our choices, Harry, that show what we truly are, far more than our abilities.",
            "author":9
        },
        {
            "quote": "All happy families are alike; each unhappy family is unhappy in its own way.",
            "author":10
        },
        {
            "quote":"It is better to be hated for what you are than to be loved for what you are not.",
            "author":11
        },
        {
            "quote":"The only way to do great work is to love what you do.",
            "author": 12
        },
        {
            "quote":"There is nothing to writing. All you do is sit down at a typewriter and bleed.",
            "author":13
        },
        {
            "quote":"Beware; for I am fearless, and therefore powerful.",
            "author":14
        },
        {
            "quote":"It does not do to dwell on dreams and forget to live.",
            "author":2
        },
        {
            "quote":"It takes courage to grow up and become who you really are.",
            "author":15
        },
        {
            "quote":"Do not go where the path may lead, go instead where there is no path and leave a trail.",
            "author":5
        },
        {
            "quote":"It is not what you look at that matters, it is what you see.",
            "author":16
        },
        {
            "quote":"Life is what happens to us while we are making other plans",
            "author":17
        },
        {
            "quote":"The only thing necessary for the triumph of evil is for good men to do nothing.",
            "author":18
        },
        {
            "quote":"The greatest glory in living lies not in never falling, but in rising every time we fall.",
            "author":19
        },
        {
            "quote":"The journey of a thousand miles begins with one step.",
            "author":20
        },
        {
            "quote":"The best way to predict the future is to invent it.",
            "author":21
        },
        {
            "quote":"The only true wisdom is in knowing you know nothing.",
            "author":22
        },
        {
            "quote":"The only thing we have to fear is fear itself.",
            "author":23
        },
        {
            "quote":"In the end, it is not the years in your life that count. It is the life in your years.",
            "author":24
        },
        {
            "quote":"I am not a product of my circumstances. I am a product of my decisions.",
            "author":25
        },
        {
            "quote":"The mind is everything. What you think you become.",
            "author":26
        },
        {
            "quote":"Believe you can and you are halfway there.",
            "author":27
        },
        {
            "quote":"To love oneself is the beginning of a lifelong romance.",
            "author":28
        },
        {
            "quote":"The future belongs to those who believe in the beauty of their dreams.",
            "author":29
        },
        {
            "quote":"It is not whether you get knocked down, it is whether you get up",
            "author":30
        },
        {
            "quote":"It always seems impossible until it is done.",
            "author":19
        },
        {
            "quote":"The only limit to our realization of tomorrow will be our doubts of today.",
            "author":23
        },
        {
            "quote":"You must be the change you wish to see in the world.",
            "author":31
        },
        {
            "quote":"There is no greater agony than bearing an untold story inside you.",
            "author":6
        },
        {
            "quote":"Darkness cannot drive out darkness: only light can do that. Hate cannot drive out hate: only love can do that.",
            "author":32
        },
        {
            "quote":"In three words I can sum up everything I have learned about life: it goes on.",
            "author":33
        },
        {
            "quote":"Do not judge each day by the harvest you reap but by the seeds that you plant.",
            "author":34
        }
    ]
}' >> db/quotes.json
#Install packages
npm i express dotenv knex sqlite3
#Create database
node db/create-db.js
#Remove db creating script && mock data:
rm db/create-db.js && rm db/quotes.json

echo "# $name

This API has been developed using [BYFA](https://github.com/charlinchui/byfa-cli), a tool designed to rapidly scaffold API projects across various frameworks and programming languages. It is by default an API that returns Quotes and Authors.

## Database

The API is integrated with a SQLite database, located within the **db** directory.

### Database Configuration

To modify the database configuration, you'll need to adjust the settings in the **knexfile.js**. This file contains the configuration for connecting to the database and can be found in the project directory. Make any necessary changes to the **knexfile.js** to update the database settings according to your requirements.

## Modifying Endpoints

In order to make your own API, you might want to modify the current endpoints, to do so:

1. **Service Modifications**:
   - Navigate to the **services.js** file or create a new one as needed.
   - Implement changes within the **services.js** file or create a new file to introduce additional services, ensuring to import it from the router.

2. **Router Adjustments**:
   - Access the **router.js** file to append or remove routes.
   - For customized routing, consider crafting your own routers, while ensuring their inclusion within the Express app in the **index.js** file.

3. **Database Edit**:
   - Delete db/db.sqlite3
   - Create a new script (ex. create_db.js)
   - Import the DB from the knex file using **const db = require("./db/knexfile")** on the first line of create_db.js
   - Create a new table using : 
    **db.schema.createTable('table_name', (table)=>{db.schema.createTable('new_table', (table)=>{
        table.increments('id');
        table.string('my_string_column');
        table.integer('my_integer_value');
    });** ([knex reference here](https://www.npmjs.com/package/knex))
   - Run the script by running the command **node /path/to/create_db.js**
   - It will generate a new database file with the specified table. You can generate multiple tables for your database following the same pattern.

## Project Execution

To execute the project:

- Utilize **npm run start** to initiate the project (Node.js and npm prerequisites).
- Opt for **npm run start:dev** to engage developer mode (requiring Node.js, npm, and nodemon).

## Endpoint Testing

For comprehensive endpoint evaluation, we recommend the use of CURL, Postman, or Insomnia.

Happy coding! :D
" >> README.MD
git init -b main
echo ".env
node_modules
package-lock.json" >> .gitignore
echo "
New API project created.

Next steps:

    cd $name
    npm run start

Happy Coding! :D
"
