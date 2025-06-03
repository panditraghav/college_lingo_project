chunks = [
    "The",
    " lighthouse",
    " keeper, Silas, was a man made of salt and storms. His beard was white",
    " and wild, mirroring the foam that perpetually crashed against the jagged cliffs below. He'd",
    " lived at the beacon for fifty years, the rhythmic pulse of its light his only companion. He knew the moods of the sea like a lover, understanding its whispers",
    " and its roars.\n\nOne day, a storm descended unlike any he'd seen before. The wind howled like a banshee, tearing at the lighthouse",
    " walls. Waves, monstrous and black, clawed at the base, shaking the very foundations. Silas clung to the railings, his heart a frantic drum against his ribs. He'd weathered countless storms, but this one felt different. Male",
    "volent. Personal.\n\nThen, he saw her.\n\nAdrift in the churning waters, clinging to a piece of driftwood, was a young woman. Her hair, the color of seaweed, whipped around her face, and her eyes, wide",
    " with terror, were fixed on the lighthouse light.\n\nSilas knew he had to act. He wasn't a young man anymore, his joints creaked and protested, but the sea was taking her, and he couldn't let that happen.\n\nHe struggled to lower the small rescue boat, fighting against the gale. The",
    " wind tore at him, the rain stung his face, but he persisted, driven by a primal urge to save her. Finally, the boat splashed into the raging sea.\n\nNavigating the treacherous waters was a dance with death. Waves crashed over the bow, threatening to swallow him whole. But Silas, guided by the faint",
    " glimmer of the woman's pale face, pressed on.\n\nHe reached her just as she was about to lose her grip. He hauled her, weak and shivering, into the boat, then fought his way back to the lighthouse.\n\nHe wrapped her in thick blankets, fed her warm broth, and listened to her story. Her",
    " name was Elara, and she'd been sailing to visit her aunt when her ship was caught in the storm.\n\nAs the storm raged outside, Silas and Elara found solace in each other's company. He told her stories of the sea, of shipwrecks and rescues, of the loneliness and the beauty",
    " of being a lighthouse keeper. She told him of her dreams, of the bustling city she called home, of her love for music and art.\n\nFor days, they were stranded, the storm their only companion. Silas found himself looking forward to her stories, to the way her eyes lit up when she spoke of her life.",
    " He hadn't felt this alive in years.\n\nFinally, the storm subsided. The sun broke through the clouds, painting the sea with gold. A rescue ship arrived, ready to take Elara home.\n\nAs she stood on the deck of the ship, ready to leave, Elara turned to Silas. Her",
    " eyes, now filled with gratitude, met his. \"Thank you, Silas,\" she said, her voice barely audible above the gentle lapping of the waves. \"You saved my life.\"\n\n\"You saved mine, too, Elara,\" Silas replied, his voice raspy with emotion. He hadn't realized how empty",
    " his life had become until she arrived.\n\nElara smiled, a genuine, radiant smile that warmed Silas to his core. \"I'll never forget you,\" she said, then turned and walked onto the ship.\n\nSilas watched the ship disappear over the horizon. He felt a pang of sadness, but also",
    " a sense of peace. He was still alone in his lighthouse, but he was no longer the same man. Elara had brought a spark of light back into his life, a reminder that even in the darkest of storms, there is always hope, and that even the loneliest hearts can find connection. He looked out at",
    " the sea, now calm and serene, and knew that he would never forget the woman who had washed ashore in the storm, the woman who had changed his life forever. He turned back to the lighthouse, the rhythmic pulse of its light a beacon not just for ships at sea, but for the newfound hope in his own heart.",
    "\n"
]

def unsplit():
    full_stop_list: list[str] = []
    curr = ""
    for chunk in chunks:
        full_stop_index = chunk.find(". ", 0, -1)

        if full_stop_index == -1:
            curr += chunk
        else:
            curr += chunk[0:full_stop_index + 1]
            full_stop_list.append(curr)
            curr = chunk[full_stop_index + 2: -1]

    print(full_stop_list)

unsplit()
# c = chunks[5]
# i = chunks[5].find(".\n\n")
# print(c, i)
# print(c[i])

st = "Here's a stanza from Robert Frost's \"Stopping by Woods on a Snowy Evening\":\n\nThe woods are lovely, dark and deep,\nBut I have promises to keep,\nAnd miles to go before I sleep,\nAnd miles to go before I sleep.\n"
